-- | Check if an action is dependent on another.
--
-- This is basically the same as 'dependent'', but can make use of the
-- additional information in a 'ThreadAction' to make better decisions
-- in a few cases.
dependent :: DepState -> ThreadId -> ThreadAction -> ThreadId -> ThreadAction
          -> Bool
dependent ds t1 a1 t2 a2 = case (a1, a2) of
  -- @SetNumCapabilities@ and @GetNumCapabilities@ are NOT dependent
  -- IF the value read is the same as the value written. 'dependent''
  -- can not see the value read (as it hasn't happened yet!), and so
  -- is more pessimistic here.
  (SetNumCapabilities a, GetNumCapabilities b) | a == b -> False
  (GetNumCapabilities a, SetNumCapabilities b) | a == b -> False

  -- When masked interruptible, a thread can only be interrupted when
  -- actually blocked. 'dependent'' has to assume that all
  -- potentially-blocking operations can block, and so is more
  -- pessimistic in this case.
  (ThrowTo t, _) | t == t2 -> canInterrupt ds t2 a2 && a2 /= Stop
  (_, ThrowTo t) | t == t1 -> canInterrupt ds t1 a1 && a1 /= Stop

  -- Dependency of STM transactions can be /greatly/ improved here, as
  -- the 'Lookahead' does not know which @TVar@s will be touched, and
  -- so has to assume all transactions are dependent.
  (STM _ _, STM _ _)           -> checkSTM
  (STM _ _, BlockedSTM _)      -> checkSTM
  (BlockedSTM _, STM _ _)      -> checkSTM
  (BlockedSTM _, BlockedSTM _) -> checkSTM
  _ -> case (,) <$> rewind a1 <*> rewind a2 of
    Just (l1, l2) -> dependent' ds t1 a1 t2 l2 && dependent' ds t2 a2 t1 l1
    _ -> dependentActions ds (simplifyAction a1) (simplifyAction a2)

  where
    -- STM actions A and B are dependent if A wrote to anything B
    -- touched, or vice versa.
    checkSTM = checkSTM' a1 a2 || checkSTM' a2 a1
    checkSTM' a b =
      not . S.null $ tvarsWritten a `S.intersection` tvarsOf b

-- | Variant of 'dependent' to handle 'Lookahead'.
--
-- Termination of the initial thread is handled specially in the DPOR
-- implementation.
dependent' :: DepState -> ThreadId -> ThreadAction -> ThreadId -> Lookahead
           -> Bool
dependent' ds t1 a1 t2 l2 = case (a1, l2) of
  -- Worst-case assumption: all IO is dependent.
  (LiftIO, WillLiftIO) -> True

  -- Throwing an exception is only dependent with actions in that
  -- thread and if the actions can be interrupted. We can also
  -- slightly improve on that by not considering interrupting the
  -- normal termination of a thread: it doesn't make a difference.
  (ThrowTo t, WillStop) | t == t2 -> False
  (Stop, WillThrowTo t) | t == t1 -> False
  (ThrowTo t, _)     | t == t2 -> canInterruptL ds t2 l2
  (_, WillThrowTo t) | t == t1 -> canInterrupt  ds t1 a1

  -- Another worst-case: assume all STM is dependent.
  (STM _ _, WillSTM) -> True

  -- This is a bit pessimistic: Set/Get are only dependent if the
  -- value set is not the same as the value that will be got, but we
  -- can't know that here. 'dependent' optimises this case.
  (GetNumCapabilities a, WillSetNumCapabilities b) -> a /= b
  (SetNumCapabilities _, WillGetNumCapabilities)   -> True
  (SetNumCapabilities a, WillSetNumCapabilities b) -> a /= b

  _ -> dependentActions ds (simplifyAction a1) (simplifyLookahead l2)

-- | Check if two 'ActionType's are dependent. Note that this is not
-- sufficient to know if two 'ThreadAction's are dependent, without
-- being so great an over-approximation as to be useless!
dependentActions :: DepState -> ActionType -> ActionType -> Bool
dependentActions ds a1 a2 = case (a1, a2) of
  -- Unsynchronised reads and writes are always dependent, even under
  -- a relaxed memory model, as an unsynchronised write gives rise to
  -- a commit, which synchronises.
  (UnsynchronisedRead r1, _)
    | same crefOf && a2 /= PartiallySynchronisedCommit r1 ->
      a2 /= UnsynchronisedRead r1
  (UnsynchronisedWrite r1, _)
    | same crefOf && a2 /= PartiallySynchronisedCommit r1 -> True
  (PartiallySynchronisedWrite r1, _)
    | same crefOf && a2 /= PartiallySynchronisedCommit r1 -> True
  (PartiallySynchronisedModify r1, _)
    | same crefOf && a2 /= PartiallySynchronisedCommit r1 -> True
  (SynchronisedModify r1, _)
    | same crefOf && a2 /= PartiallySynchronisedCommit r1 -> True

  -- Unsynchronised writes and synchronisation where the buffer is not
  -- empty.
  --
  -- See [RMMVerification], lemma 5.25.
  (UnsynchronisedWrite r1, PartiallySynchronisedCommit _)
    | same crefOf && isBuffered ds r1 -> False
  (PartiallySynchronisedCommit _, UnsynchronisedWrite r2)
    | same crefOf && isBuffered ds r2 -> False

  -- Unsynchronised reads where a memory barrier would flush a
  -- buffered write
  (UnsynchronisedRead r1, _) | isBarrier a2 -> isBuffered ds r1
  (_, UnsynchronisedRead r2) | isBarrier a1 -> isBuffered ds r2

  -- Commits and memory barriers must be dependent, as memory barriers
  -- (currently) flush in a consistent order.  Alternative orders need
  -- to be explored as well.  Perhaps a better implementation of
  -- memory barriers would just block every non-commit thread while
  -- any buffer is nonempty.
  (PartiallySynchronisedCommit _, _) | isBarrier a2 -> True
  (_, PartiallySynchronisedCommit _) | isBarrier a1 -> True

  (_, _) -> case getSame crefOf of
    -- Two actions on the same CRef where at least one is synchronised
    Just r -> synchronises a1 r || synchronises a2 r
    -- Two actions on the same MVar
    _ -> same mvarOf

  where
    same :: Eq a => (ActionType -> Maybe a) -> Bool
    same = isJust . getSame

    getSame :: Eq a => (ActionType -> Maybe a) -> Maybe a
    getSame f =
      let f1 = f a1
          f2 = f a2
      in if f1 == f2 then f1 else Nothing
