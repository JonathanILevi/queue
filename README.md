# Queue
An implemention of a Queue, internally on an SList.

This Queue is thread safe (and block-free) to have separate threads reading and writing asynchronously.  The Queue is NOT safe to have multiple threads reading or writing at the same time.  i.e. A single thread can read while another single thread is writing.
If you want to have mutiple threads reading or writing data from queue the threads will need to be sure to block themself.

To Create a `Queue`
---
    Queue!string queue; // Replace string with data type that values should be.


To add to `queue`
---
    queue.put("This is a value that is added to queue!"); // Argument should be of oppropriate type.

To read from `queue`
---
    foreach (string value; queue) {
        // Deal with value here!
    }
or

    if (!queue.empty) {
        auto value = queue.front;// Get next value in queue.
        queue.popFront;// To remove the first item to move the queue forward to the next item.
    }

Separate threads reading and writing (example)
----
    /*
    This example will take user input from one thread and use it in another.
    */
    import core.thread;
    import std.stdio;
    
    void main() {
      // Create Queue for Thread messages
      Queue!string inputQueue = new Queue!string;
      
      // Start thread that will add user input from console to queue.
      InputThread inputThread = new InputThread(inputQueue);
      inputThread.start;
      
      // Main loop for this thread to read data from queue and act on it.
      while (true) {
        // Loop through values in queue (consuming the queue as you go)
        foreach (string value; inputQueue) {
          // Do something with values.
          writeln(value);
        }
      }
    }
    
    // Thread class
    // Will continually add user input to the queue.
    class InputThread : Thread {
      private Queue!string queue;
      
      this(Queue!string queue) {
        super(&run);
        this.queue = queue;
      }
      
      private void run() {
        // Will continually add user input to the queue.
        while (true) {
          queue.put(readln);
        }
      }
    }

Multiple threads reading
---
    synchronized {
        foreach (string value; queue) {
            // Deal with value here!
        }
    }
or

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
