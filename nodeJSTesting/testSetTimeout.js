
var copy = [];

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

