
/**START test while */
var x, y = true;
while ( x = y){
    console.log(x);
    y = false;
}

/**END */

/**START promise priority https://stackoverflow.com/questions/38752620/promise-vs-settimeout*/
var p = new Promise(function (resolve, reject) {
    for (i = 0; i < 1000; i++) {}
    resolve();
}).then(function () {
    console.log('from then of promise');
});
setTimeout(function () {
    console.log('from timeout');
}, 0);


/**END */
//START test db feature
var arr = [{
    serviceName: "s1",
    features: [{componentName: 'c1', featureName: 'f1', featureVersion: 2},{componentName: 'c1', featureName: 'f2', featureVersion: 2}]
}, {
    serviceName: "s2",
    features: [{componentName: 'c1', featureName: 'f1', featureVersion: 2},{componentName: 'c1', featureName: 'f2', featureVersion: 2}]
}];

var arr1 = [{componentName: 'c1', featureName: 'f1', featureVersion: 2},{componentName: 'c1', featureName: 'f2', featureVersion: 2}];
//var acc = {};
var res = arr1.reduce(function(acc, curr){
    acc[curr.componentName+"$"+curr.featureName] = curr.featureVersion;
    return acc;
},{});

var res1 = arr.reduce(function (acc, service) {
    acc[service.serviceName] = {};
    service.features.reduce(function (acc, feature) {
        acc[feature.componentName + "$" + feature.featureName] = {featureVersion: feature.featureVersion};

        return acc;
    }, acc[service.serviceName]);
    return acc;
}, {});
console.log(res1);
console.log('------------');
console.log(res);
//arr.reduce();
//END test db feature

//testing empty array.
var attributes = [];
attributes.forEach(function(attribute){
    console.log("comes");
    console.log(attribute)
});

try{
    setTimeout(function(){
        console.log("try..");
    }, 8000);
}finally{
    setTimeout(function(){
        console.log("finally");
    },4000);
}

//test miss function parameters.
function func(p1,p2,p3){
    console.log(p1);
    console.log(p2);
    console.log(p3);
    //console.log(p4);
}

func(1,2);