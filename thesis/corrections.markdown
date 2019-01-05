This is a list of the mandatory corrections and how I have met them.

Abstract
--------

* Summarise the motivation, novelty and relevance of the work.

This now states that we concurrency testing algorithms are typically
presented for simple languages, yet we want to apply them to complex
languages; and briefly mentions the work with daemon threads and trace
simplification.


Introduction
------------

* Identify the motivation, including a clear identification of the
  problem addressed in the thesis.

The opening of the chapter has been rewritten to clarify that we are
interested in systematically testing concurrent programs, where stress
testing approaches are unable to give certainty.

* Identify objectives of your research.

Section 1.2, "Goals and Contributions of this Thesis", now states
specifically what we want to achieve.

* Give a more detailed and concrete list of contributions.

Section 1.2, "Goals and Contributions of this Thesis", now gives a
list of smaller contributions we achieve as part of our more major
contributions.

* Justify the relevance of the contributions, referring already to
  gaps in the literature, and the improved position of a developer
  that can take advantage of your results.

Section 1.2, "Goals and Contributions of this Thesis", now gives a
brief justification for each contribution.

* Give a diagram (or other road-map) showing how the parts fit
  together.

Section 1.3, "Roadmap" (was "Chapter Preview"), now states how the
chapters build on each other.


Chapter 2
---------

* Add a precise characterisation of the concurrency model of interest.

* Add a brief discussion of the programming languages that adopt or
  can adopt this concurrency model, as a basis to justify the
  generality of results.

* Briefly dentify the challenges imposed by the concurrency model that
  you characterise to achieve the objectives of the work identified in
  the introduction.

Section 2.1, "The Concurrency Model", is a new section to cover these
three points.

Chapter 3
---------

No mandatory corrections.


Chapter 4
---------

* Literature review here is purely descriptive, and at a point even
  degenerates to list. Add a critical discussion, in the light of the
  problem that you set up to solve as identified in the
  introduction. In the conclusions, get back to the closely related
  works and compare them to your results.

Section 4.2, "Property-based Testing Tools", ties the discussion into
the larger context of the work, with forward references to chapters 5
and 7.  The list of tools was intended to serve as evidence for the
widespread popularity of property-based testing, and has been
restructured to make this clearer.

Section 4.3, "Searching for Properties", clarifies that chapter 7
builds on the foundation laid by these tools.


Chapter 5
---------

* Please take a whole subsection to explain what bugs Deja Fu can
  detect.

* Please explain more carefully, early in the chapter, what Deja Fu
  does and (in outline) how it works.

Section 5.1, "What is Deja Fu?", is a new section to cover both of
these points.  This also includes the old "scope" section, covering
what bugs are out-of-scope for Deja Fu.

* Please revise the operational semantics so that is complete and
  precise.

Section 5.5, "Operational Semantics", has been totally rewritten to
incorporate all of the examiners suggestions.

* Make more of trace simplification! Spell out the trace
  simplification algorithm in a precise way.

Section 5.7, "Execution traces", gives the syntax of traces
(previously contained in one of the case studies), and a precise
(prose) description of the algorithm, with examples for two of the
trickier steps.

* Explain more carefully your clever combination of QuickCheck and
  Deja Fu.

Section 5.9.3, "async", clarifies the meaning of the property, and
gives a forward reference to chapter 7.

* Be clear about what is your novel contribution and what are existing
  algorithms that you reused without difficulties.

Page 83, the re-use of sleep sets was clarified.

* Discuss the impact of the treatment of termination.

Page 85, now has a paragraph clarifying that this can cause redundant
schedules to be explored.

* Section 5.7: define the notion of correctness.

This is now explicitly stated.

* Section 5.8: strengthen the argument that your changes do not
  introduce errors.

The monad-par and auto-update case studies have been swapped, so that
monad-par (and its description of the needed changes) comes first.

* Separate the users-eye-view of Déjà Fu from the implementation.

Section 5.2, "Abstracting over Concurrency", clarifies that part of
its discussion is related to the implementation.

Section 5.4 has been renamed from "Executing Concurrent Programs" to
"Modelling Concurrent Programs".

Section 5.6, "Testing Concurrent Programs", now opens with a summary
of the testing methods available, rather than a list of all of the
components of a test.


Chapter 6
---------

* The second last para on p107 (Multiple executions can use the same
  thread weights...)  makes no sense, and should be removed.

This has been removed.

* Please fix the very confusing description of bug depth on p106.

The description of bug depth has been rewritten and moved further up,
into the paragraph describing PCT.

Chapter 7
---------

* Please be much more explicit about what it means to be “equivalent
  to” and “a refinement of”.

* Describe the big picture early.

Section 7.1, "Concurrency Properties" (was "Key Concerns of Observing
Concurrent Programs"), covers both of these.  It discusses more
explicitly what properties mean, and says that CoCo uses Deja Fu to
find the results of generated program fragments (with a back reference
to a discussion of the equivalence checker in Deja Fu).


Chapter 8
---------

* Revisit the motivation and objectives set out in the introduction
  and link the discussion to that.

The motivation from the introduction is revisited here.


Chapter 9
---------

* Collect the several suggestions of future work throughout the thesis
  here.

"Invariant testing in Deja Fu" and "Automatic interference for CoCo"
have been added.
