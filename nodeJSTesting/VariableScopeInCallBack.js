var var_Global = "i am global";

function externalCB(){
    console.log("externalCB");
    console.log("Global var:"+var_Global);
    //console.log("Inside var:"+insideCB?insideCB:"not defined");
}

function main(cb){
    var var_Inside = "i am inside";
    var insideCB = function(){
        console.log("insideCB");
        console.log("Global var:"+var_Global);
        console.log("Inside var:"+var_Inside);
    }
    console.log("calling cb");
    cb();
    insideCB();
};

main(externalCB);