module container.queue;

import std.traits: hasIndirections;

struct GrowableCircularQueue(T) {
    public size_t length;
    private size_t first, last;
    private T[] A = [T.init];

    this(T[] items...) @safe {
        foreach (x; items)
            push(x);
    }

    @property bool empty() const @safe {
        return length == 0;
    }

    @property T front() nothrow @safe {
        assert(length != 0);
        return A[first];
    }

    T opIndex(in size_t i) nothrow @safe {
        assert(i < length);
        return A[(first + i) & (A.length - 1)];
    }

    void push(T item) @safe {
        if (length >= A.length) { // Double the queue.
            immutable oldALen = A.length;
            A.length *= 2;
            if (last < first) {
                A[oldALen .. oldALen + last + 1] = A[0 .. last + 1];
                static if (hasIndirections!T)
                    A[0 .. last + 1] = T.init; // Help for the GC.
                last += oldALen;
            }
        }
        last = (last + 1) & (A.length - 1);
        A[last] = item;
        length++;
    }

    @property T pop() @safe {
        assert(length != 0);
        auto saved = A[first];
        static if (hasIndirections!T)
            A[first] = T.init; // Help for the GC.
        first = (first + 1) & (A.length - 1);
        length--;
        return saved;
    }
}