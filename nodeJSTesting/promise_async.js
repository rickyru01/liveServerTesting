//test start
let promiseWithoutAsync = new Promise((res, rej) => {
   // console.log("execution done without aync");
    res("done")
});

promiseWithoutAsync.then(() => {
   // console.log("then is called");
});
//console.log("main is called");

//The following output indicates the callback is called after the main thread is finished.

// execution done without aync
// main is called
// then is called
//test end

//test start
console.log("test vs code file opeartion start");
var create = async function(){
    p = new Promise((res, rej) => {res("release cpu");});
    await p;
    console.log("create");
};

var rename = function(){
    console.log("rename");
};

var funcs = [create, rename];

for (var i = 0; i<funcs.length; i++){
    funcs[i]();
}
//test end

