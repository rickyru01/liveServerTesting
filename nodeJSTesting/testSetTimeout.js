/*
for (var i = 0; i < 6; i++) {
    copy.push(i);
    setTimeout(function () {
        console.log(copy.shift());
    }, i * 1000);
};



for (var i = 0; i < 6; i++) {
    setTimeout(function () {
        console.log(i);
    }, 0);//no delay
    console.log('main thread');
};

*/

var testPromieseWithSetTimeout = function(){
    for (var i = 0; i<50; i++){
        var p1 = new Promise(function(res, rej){
            res('done');
        });
        p1.then(function(msg){
            console.log(msg);
        });
    }
    setTimeout(function(){console.log('this is time out')},0);
}

testPromieseWithSetTimeout();
