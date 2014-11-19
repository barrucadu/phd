public class Stack {
    protected List contents;

    /*@ public model int entries;
      @ public model Object head;
      @ protected represents entries = contents.size();
      @ protected represents head =
      @   (entries == 0) ? null : contents.get(entries - 1);
      @*/

    /*@ requires entries > 0;
      @ ensures entries == \old(entries) - 1;
      @ ensures \result == \old(head);
      @*/
    public Object pop() {
        ...
    }
}
