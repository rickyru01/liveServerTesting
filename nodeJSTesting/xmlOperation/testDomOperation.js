var fs = require("fs");


fs.readFile("test.txt", "utf8", function(err, data) {
    var dom = parseDocument(data);

});

function parseDocument( content ) {
    var parser = new DOMParser();
    var result = null;
    try {
        result = parser.parseFromString( content, "text/xml" );
    } catch( e ) {
        // IE9+
        throw new XmlReaderException( null, e.toString() );
    }
    checkParserError( result );
    return result;
}