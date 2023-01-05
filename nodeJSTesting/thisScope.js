function People(name, age) {
    this.name = name;
    this.age = age;
}

function peopleHelper(cback){
    console.log('go to peopleHelper')
    cback();
}

People.prototype = {

    walk: function () {
        console.log(this.name + " is walking");
    },
    eat: function () {
        console.log(this.name + "is eating");
    },
    testCallBack(){
        var that = this;
        peopleHelper(function(){
            that.eat();
        });
    }
}

var p = new People("ricky", 33);
p.testCallBack();