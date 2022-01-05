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
    console.log(p4);
}

func(1,2);