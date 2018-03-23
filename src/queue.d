/**
An implemention of a Queue.

This Queue is thread safe (and block-free) to have separate threads reading and writing asynchronously.  The Queue is NOT safe to have multiple threads reading or writing at the same time.  i.e. A single thread can read while another single thread is writing.
If you want to have mutiple threads reading or writing data from queue the threads will need to be sure to block themself.

To Create a queue
---
Queue!string queue; // Replace string with data type that values should be.
---

To add to queue
---
queue.put("This is a value that is added to queue!"); // Argument should be of oppropriate type.
---

To read data
---
foreach (string value; queue) {
// Deal with value here!
}
---

To read data safe to have multiple threads reading
---
synchronized {
foreach (string value; queue) {
// Deal with value here!
}
}
---
or
---
while (true) {
string value;
synchronized {
if (queue.empty) {
break;
}
value = queue.front;
queue.popFront;
}
// Deal with value here!
}
---

Examples:
---
Queue!string queue; 

queue.add("A!");
queue.add("BBB!");
queue.add("CC!");

foreach (string value; queue) {
writeln(value);
}

queue.add("DDDDD!");
queue.add("EEEE!");

foreach (string value; queue) {
writeln(value);
}
---
*/

module queue;

import core.atomic : atomicOp;
////import core.sync.semaphore : Semaphore;

class Queue(T) {

	//private struct HeadNode {
	//    Node* _first;
	//}
	private struct Node {
		T     payload;
		Node* next;
	}

	private Node* _first;
	private Node* _last = new Node;
	shared private int   count = 0;

	this() {
		this._first = this._last;
	}

	/**	Add to the Queue (to the end).
	*/
	void put(T value) {
		Node* newLast = new Node;
		this._last.payload = value;
		this._last.next = newLast;
		this._last = newLast;
		
		count.atomicOp!("+=")(1);
	}


	/**	To be iterable with `foreach` loop.
	*/
	bool empty() {
		return this.count == 0;
		////return _head._first == null;
	}

	/// ditto
	void popFront() {
		assert (!this.empty);
		this._first = this._first.next;
		count.atomicOp!("-=")(1);
	}

	///ditto
	T front() {
		assert (!this.empty);
		return this._first.payload;
		////}
		////else {
		////    return null;
		////}
	}

}



////void main(){
////    import core.thread;
////    import std.stdio;
////    class ThreadInput : Thread {
////        private Queue!string queue;
////
////        this(Queue!string queue) {
////            super(&run);
////            this.queue = queue;
////        }
////
////        private void run() {
////            while (true) {
////                queue.put(readln);
////            }
////        }
////    }
////    Queue!string inputQueue = new Queue!string;
////    ThreadInput threadInput = new ThreadInput(inputQueue);
////    threadInput.start;
////
////    while (true) {
////        foreach (string value; inputQueue) {
////            writeln(value);
////        }
////    }
////    
////
////
////}
