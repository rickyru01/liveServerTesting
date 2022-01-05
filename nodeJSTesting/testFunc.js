
this.fs = require( 'fs' );
this.file = '/home/ricky/log.js';
this.fsCB = function( err ){
    if( err ) return console.log( err );
};

this.fs.appendFile(this.file, 'aaa', this.fsCB);
var procRows = [
    {PARAMETER_NAME: '$$ip1$$'},
    {PARAMETER_NAME: '$$client$$'},
    {PARAMETER_NAME: '$$language$$'}
];

procRows = procRows.filter( function( row ){
    return( row.PARAMETER_NAME !== '$$client$$' && row.PARAMETER_NAME !== '$$language$$' );
});
var virtualTableParameters = procRows.map( function( row ){
    row.name = row.PARAMETER_NAME;
    delete row.PARAMETER_NAME;
    return row;
});

console.log(virtualTableParameters);