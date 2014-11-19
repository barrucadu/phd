public class Stack implements IContract {
    protected List<T> contents;

    public T pop() {
        Require.begin();
        assert contents.size() > 0 : "Stack empty";
        Require.end();

        ...
    }
}
