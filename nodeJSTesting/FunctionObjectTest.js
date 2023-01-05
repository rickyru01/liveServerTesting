function Target(){
    this.name = 'test';
}

Target.prototype.fun1 = function(){
    this.name='test1';
    console.log('fun1');
    Target.attach1();
}

Target.attach1 = function(){
    console.log('attach1');
    console.log(this.name);
};


var t = new Target();

t.fun1();
//Target.attach1();//failed