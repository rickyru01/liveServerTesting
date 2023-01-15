
/* 
 * 正则表达式测试
 */
var ouputMatches = function (matches) {
    for (var match of matches) {
        console.log(match);
        console.log(match.index);
    }
}
/**
 * the non capturing group (?: will not impact the group inside it.
 * the whole match is always there. So if () is around the whole regex, you get 2 whole matches.
 */
var testNonCapturingGroup = function(){
    var regex = /((a|b).(xyz))/g;
    ouputMatches('a-xyz'.matchAll(regex));
    'a-xyz'.replace(regex, function(match, g1,g2,g3){ // the callback called each time for a match.
        console.log(arguments);
        return '';
    });
    regex = /(?:(a|b).(xyz))/g;
    ouputMatches('a-xyz'.matchAll(regex));

    regex = /(?:a|b).(xyz)/g
    ouputMatches('a-xyz'.matchAll(regex));
    ouputMatches('a-xyz$b>xyz'.matchAll(regex));//  2 matches. the index is the offset where this match starts

}
//testNonCapturingGroup();

var testRegExWithOr = function(){
    var regex = /(?:((123)abc)|(456)|(789))/g;
    ouputMatches('0123abc456789'.matchAll(regex));
    '0123abc456789'.replace(regex, function(match, g1,g2,g3){
        console.log(arguments);
        return '';
    });
}
//testRegExWithOr();
//会不会在匹配里面再找匹配，不会。匹配是一直向前的。
var testMatchInMatch = function(){
    var regex = /abc.*/g;
    var str = 'abc---abc---';
    ouputMatches(str.matchAll(regex));
};
testMatchInMatch();

var testSqlComment = function(){
    var regex =  /(--[^\n\r]*[\n\r]*)/g;
    regex =  /([^\'].*--[^\n\r]*[\n\r]*)/g;

    var str = '--this is comment';
    str = '\n\r -- this is comment';
    str = 'aaa\n\r aaa -- this is comment';
    str = 'aaa\n\r aaa \'-- this is comment';
    str = '\'name\'sdfsd-- this is a comment'
    str = 'aaa\n\r aaa \'-- xx\' this is NOT comment';
    str = '\'\n\r-- this is a comment';
    str = '\'\n\r-- aaa this is a comment \n\r \n\raaaa';
}

var testRemovingComments = function(){
    var ADW_GLOBALS = new Object();
    ADW_GLOBALS = {
        quotations: /((["'])(?:(?:\\\\)|\\\2|(?!\\\2)\\|(?!\2).|[\n\r])*\2)/,
        multiline_comment: /(\/\*(?:(?!\*\/).|[\n\r])*\*\/)/,
        single_line_comment: /(\/\/[^\n\r]*[\n\r]*)/,
        regex_literal: /(?:\/(?:(?:(?!\\*\/).)|\\\\|\\\/|[^\\]\[(?:\\\\|\\\]|[^]])+\])+\/)/,
        html_comments: /(<!--(?:(?!-->).)*-->)/,
        sql_comments: /(--[^\n\r]*[\n\r]*)/,
        regex_of_doom: ''
    };
    ADW_GLOBALS.regex_of_doom = new RegExp(
        '(?:' + ADW_GLOBALS.quotations.source + '|' +
        ADW_GLOBALS.multiline_comment.source + '|' +
        ADW_GLOBALS.single_line_comment.source + '|' +
        '((?:=|:)\\s*' + ADW_GLOBALS.regex_literal.source + ')|(' +
        ADW_GLOBALS.regex_literal.source + '[gimy]?\\.(?:exec|test|match|search|replace|split)\\(' + ')|(' +
        '\\.(?:exec|test|match|search|replace|split)\\(' + ADW_GLOBALS.regex_literal.source + ')|' +
        ADW_GLOBALS.html_comments.source + '|' +
        ADW_GLOBALS.sql_comments.source + ')', 'g'
    );
    //console.log(ADW_GLOBALS.regex_of_doom);
    var replaceFunc = function (match, $1, $2, $3, $4, $5, $6, $7, $8, $9, offset, original) {
        if (typeof $1 != 'undefined') { return $1; }
        if (typeof $5 != 'undefined') { return $5; }
        if (typeof $6 != 'undefined') { return $6; }
        if (typeof $7 != 'undefined') { return $7; }
       
        if (typeof $9 !== 'undefined'){
            var index = offset -1;
            var char = null;
            while(index>=0 && char!=='\n'){
                char = original.charAt(index);
                if (char === '\'' && $9.includes('\'')) return $9;
                index--;
            }
        }
        return '';
    };
    //ADW_GLOBALS.regex_of_doom = /([^']*--[^\n\r]*[\n\r]*)/g
    console.log(ADW_GLOBALS.regex_of_doom);
    var testReplacing = function(expression){
        console.log("expression:"+expression);
        var resultStr = expression.replace(ADW_GLOBALS.regex_of_doom, replaceFunc);
        console.log("result:"+resultStr);
    }
    var expression = '-- this is the comment \n\r case when "name"=\'x\' then 1 when "name"=\'y\' then 2 end;\n\r';
    testReplacing(expression);
    
    var expression = '-- this is the comment \n\r case when "name"=\'x\' then 1 when "name"=\'y\' then 2 end;\n\r -- comment again\n\r\n\r yes.';
    testReplacing(expression);

    var expression = '-- this is the comment \n\r case when "name"=\'x\' then 1 when "name"=\'--\' then 2 end;\n\r -- comment again\n\r\n\r yes.';
    testReplacing(expression);

    var expression = '-- this is the comment \n\r case when "name"=\'x\' then 1 when "name"=\'--\' then 2 end;\n\r -- comment again\n\r\n\r yes\n\r -- again\n\r';
    testReplacing(expression);

    var expression = '-- this is the comment \n\r case when "name"=\'x\' then 1 when "name"=\'--\' then 2 end;\n\r -- comment again\n\r\n\r yes\n\r -- again\n\raaaa--bbbb';
    testReplacing(expression);

    var expression = '-- this is the comment \n\r case when "name"=\'x\' then 1 when "name"=\'--\' then 2 end;\n\r -- comment again\n\r\n\r yes\n\r -- again\n\raaaa\'--bbbb';
    testReplacing(expression);

    var expression = '-- this is the comment \n\r case when "name"=\'x\' then 1 when "name"=\'--\' then 2 end;\n\r -- comment again\n\r\n\r yes\n\r -- again\n\raaaa\'--bb\'bb';
    testReplacing(expression);

    expression = '--my comment1\n\rcase when "product_name"=\'aa\' then \'bb\' when "product_name"=-- then \'yy\' end --my comment2\n\r--my comment3'
    testReplacing(expression);
    //matches = expression.matchAll(ADW_GLOBALS.regex_of_doom);
    //ouputMatches(matches);
    
}

//testRemovingComments();