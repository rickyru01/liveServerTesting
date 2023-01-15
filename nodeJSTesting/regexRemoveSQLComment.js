 var regex = /(?:((["'])(?:(?:\\\\)|\\\2|(?!\\\2)\\|(?!\2).|[\n\r])*\2)|(\/\*(?:(?!\*\/).|[\n\r])*\*\/)|(\/\/[^\n\r]*[\n\r]*)|((?:=|:)\s*(?:\/(?:(?:(?!\\*\/).)|\\\\|\\\/|[^\\]\[(?:\\\\|\\\]|[^]])+\])+\/))|((?:\/(?:(?:(?!\\*\/).)|\\\\|\\\/|[^\\]\[(?:\\\\|\\\]|[^]])+\])+\/)[gimy]?\.(?:exec|test|match|search|replace|split)\()|(\.(?:exec|test|match|search|replace|split)\((?:\/(?:(?:(?!\\*\/).)|\\\\|\\\/|[^\\]\[(?:\\\\|\\\]|[^]])+\])+\/))|(<!--(?:(?!-->).)*-->)|(--[^\n\r]*[\n\r]*))/g


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