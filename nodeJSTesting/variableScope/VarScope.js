function test(p1, callback){
    console.log(p1);
    callback({name: "Ricky"});
}
function main(){
    var p1 = "this is p1";
    test(p1, function(param){
        console.log("p1 "+p1);
        console.log(param.name);
    });
}

main();
