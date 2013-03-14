// Straight up stolen from Fiddle Salad:
// https://github.com/yuguang/fiddlesalad

CodeMirror.defineMode("haml", function (config) {
  HTML_TAGS = ["a", "abbr", "acronym", "address", "applet", "area", "article", "aside", "audio", "b", "base", "basefont", "bdi", "bdo", "big", "blockquote", "body", "br", "button", "canvas", "caption", "cite", "code", "col", "colgroup", "command", "datalist", "dd", "del", "details", "dfn", "dir", "div", "dl", "dt", "em", "embed", "fieldset", "figcaption", "figure", "font", "footer", "form", "frame", "frameset", "h1", "h2", "h3", "h4", "h5", "h6", "head", "header", "hgroup", "hr", "html", "i", "iframe", "img", "input", "ins", "keygen", "kbd", "label", "legend", "li", "link", "map", "mark", "menu", "meta", "meter", "nav", "noframes", "noscript", "object", "ol", "optgroup", "option", "output", "p", "param", "pre", "progress", "q", "rp", "rt", "ruby", "s", "samp", "script", "section", "select", "small", "source", "span", "strike", "strong", "style", "sub", "summary", "sup", "table", "tbody", "td", "textarea", "tfoot", "th", "thead", "time", "title", "tr", "track", "tt", "u", "ul", "var", "video", "wbr"];

  p= function(a){console.log(a)}
    var indentUnit = config.indentUnit,
        type;

    function ret(style, tp) {
        type = tp;
        return style;
    }
        
  function wordRegexp(words) {
        return new RegExp("^((" + words.join(")|(") + "))\\b");
    }

    //html5 tags
    var tags = wordRegexp(HTML_TAGS);
    var defines = wordRegexp(["@mixin", "@include", "@import", "@media", "@extend", "@debug", "@warn"]);
    var keywords = wordRegexp(["@if", "@for", "@each", "@while"]);

    function tokenBase(stream, state) {
      if (stream.match(defines)) {
        return "def";
      } else if (stream.match(keywords)) {
        return "keyword";
      }
      
      
        var ch = stream.next();

        if (ch == "%") {
            stream.eatWhile(/[\w\-]/);
            return ret("meta", stream.current());
        } else if (ch == "/" && stream.eat("*")) {
            state.tokenize = tokenCComment;
            return tokenCComment(stream, state);
        } else if (ch == "<" && stream.eat("!")) {
            state.tokenize = tokenSGMLComment;
            return tokenSGMLComment(stream, state);
        } else if (ch == "=") ret(null, "compare");
        else if ((ch == "~" || ch == "|") && stream.eat("=")) return ret(null, "compare");
        else if (ch == "\"" || ch == "'") {
            state.tokenize = tokenString(ch);
            return state.tokenize(stream, state);
        } else if (ch == "/") { 
            stream.eatWhile(/[\a-zA-Z0-9\-_.]/);
            if (stream.peek() == ")" || stream.peek() == "/") return ret("string", "string"); //let url(/images/logo.png) without quotes return as string
            return ret("number", "unit");
        } else if (ch == "!") {
            stream.match(/^\s*\w*/);
            return ret("keyword", "important");
        } else if (/\d/.test(ch)) {
            stream.eatWhile(/[\w.%]/);
            return ret("number", "unit");
        } else if (/[,+>*\/]/.test(ch)) { //removed . dot character original was [,.+>*\/]
            return ret(null, "select-op");
        } else if (/[;{}:\[\]()]/.test(ch)) { //added () char for lesscss original was [;{}:\[\]]
            if (ch == ":") {
                stream.eatWhile(/[active|hover|link|visited]/);
                if (stream.current().match(/active|hover|link|visited/)) {
                    return ret("tag", "tag");
                } else {
                    return ret(null, ch);
                }
            } else {
                return ret(null, ch);
            }
        } else if (ch == ".") { // lesscss
            stream.eatWhile(/[\a-zA-Z0-9\-_]/);
            return ret("tag", "tag");
        } else if (ch == "#") { // lesscss
            stream.match(/([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})/);
            if (stream.current().length > 1) {
                if (stream.current().match(/([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})/) != null) {
                    return ret("number", "unit");
                } else {
                    stream.eatWhile(/[\w\-]/);
                    return ret("atom", "tag");
                }
            } else {
                stream.eatWhile(/[\w\-]/);
                return ret("atom", "tag");
            }
        } else if (ch == "&") {
            stream.eatWhile(/[\w\-]/);
            return ret(null, ch);
        } else if (ch == "-" && stream.eat("#")) {
            state.tokenize = tokenSComment;
            return tokenSComment(stream, state);
        }         
        else {
            stream.eatWhile(/[\w\\\-_.%]/);
            if (stream.eat("(")) { // lesscss
                return ret(null, ch);
            } else if (stream.current().match(/\-\d|\-.\d/)) { // lesscss match e.g.: -5px -0.4 etc...
                return ret("number", "unit");
            } else if (stream.current() in tags) { // lesscss match html tags
                return ret("tag", "tag");
            } else if ((stream.peek() == ")" || stream.peek() == "/") && stream.current().indexOf('.') !== -1) {
                return ret("string", "string"); //let url(logo.png) without quotes and froward slash return as string
            } else {
                return ret("variable", "variable");
            }
        }

    }

    function tokenSComment(stream, state) { // SComment = Slash comment
        stream.skipToEnd();
        state.tokenize = tokenBase;
        return ret("comment", "comment");
    }

    function tokenCComment(stream, state) {
        var maybeEnd = false,
            ch;
        while ((ch = stream.next()) != null) {
            if (maybeEnd && ch == "/") {
                state.tokenize = tokenBase;
                break;
            }
            maybeEnd = (ch == "*");
        }
        return ret("comment", "comment");
    }

    function tokenSGMLComment(stream, state) {
        var dashes = 0,
            ch;
        while ((ch = stream.next()) != null) {
            if (dashes >= 2 && ch == ">") {
                state.tokenize = tokenBase;
                break;
            }
            dashes = (ch == "-") ? dashes + 1 : 0;
        }
        return ret("comment", "comment");
    }

    function tokenString(quote) {
        return function (stream, state) {
            var escaped = false,
                ch;
            while ((ch = stream.next()) != null) {
                if (ch == quote && !escaped) break;
                escaped = !escaped && ch == "\\";
            }
            if (!escaped) state.tokenize = tokenBase;
            return ret("string", "string");
        };
    }

    return {
        startState: function (base) {
            return {
                tokenize: tokenBase
            };
        },

        token: function (stream, state) {
      if (stream.eatSpace()) {
              return null;
            }
            return state.tokenize(stream, state);
        }
    };
});

CodeMirror.defineMIME("text/haml", "haml");
