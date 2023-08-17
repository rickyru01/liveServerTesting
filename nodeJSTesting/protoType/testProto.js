(function() {
    var Base = function(name){
        this.name = name;
    };
    Base.prototype = {
        constructor: Base,
        getName: function(){return this.name;}
    }
    var x1 = new Base('xxx');
    var x2 = Object.create(Base.prototype);
    console.log('end');
}) ();