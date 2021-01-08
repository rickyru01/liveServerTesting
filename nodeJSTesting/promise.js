    //start:implement a promise by myself

    /*
    1.a promise representing a future value after work is completed
    2.a promise does not actually do any of the work. It wrap the idea
    of waiting the work to complete then figure out what to do after the
    work is completed. It's up to the coder who's using the promise to write the 
    executor function that does the work and then give it to the promise and the promise
    will run it.
    */

    const PENDING = 0;
    const FULFILLED = 1;
    const REJECTED = 2;

    function CustomPromise(executor) { //executor is the work to do and generate a value or error.
        let state = PENDING;
        let value = null; // the value after work is done.
        let handlers = []; //functions after work is completed. what do do after.
        let catches = []; //functions to handle errors.

        /*
        the function name does not matter!
        the resolve function is called by the executor.(the promise will pass the function
            to the executor written by the coder). executor will give it the value/result it just 
            received.
            It is the executor talks to the promise work finished or not by calling resolve/reject.
        */
        function resolve(result) {
            if (state !== PENDING) return;
            state = FULFILLED;
            value = result;
            handlers.forEach((h) => h(value));
        }

        function reject(err) {
            if (state !== PENDING) return;
            state = REJECTED;
            value = err;
            catches.forEach((c) => c(err));
        }

        this.then = function (callback) {
            if (state === FULFILLED) { //run callback immediately
                callback(value);
            } else { // or run when resolved.
                handlers.push(callback);
            }
        }
        /*Creation of the promise runs the executor function we give it.
         promise represents a process that is already running.
         It means when it(promise) is created, the work is running by calling the executor.
         
         The executor writen by the coder should exepcts a resolve and reject function. They are 
         passed to the executor so they can be used in the executor when the work is completed or when 
         an error has returned.
        */
        executor(resolve, reject);
    }

    //use it.

    const doWork = (resolve, reject) => {
        setTimeout(() => resolve("Hellow world"), 1000);
    };

    const promise = new CustomPromise(doWork);

    //added to the handlers as not resolved yet.
    promise.then((val) => {
        console.log("1st log:" + val);
    });
    promise.then((val) => {
        console.log("2st log:" + val);
    });

    //immediately run as we know it is resolved(with a value)
    setTimeout(() => {
        promise.then((val) => {
            console.log("3st log:" + val);
        });
    }, 3000);
    //end:implement a promise by myself


    //Start: Using javascript built-in Promise

    const doWork1 = (resolve, reject) => {
        setTimeout(() => resolve("Hellow world"), 1000);
    };

    const someText = new Promise(doWork);

    someText.then((val)=>console.log("builtIn 1st log:"+val));
    //End: Using javascript built-in Promise