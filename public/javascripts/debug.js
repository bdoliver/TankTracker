/// REQUIRE:
///   javascript-1.5
///   browser

//
// Debug object - debug your javascript scripts.
//
// Examples:
//
//   debug("something");
//   debug({});
//   debug(new Object());
//   debug(arguments);
//   debug(function(arg1,arg2){});
//
//   debug.print("some html");
//   debug.print_ln("some html");
//   debug.print_separator();
//   debug.print_hr();
//
//   debug.addHandler(function(arg,name,type){
//     if (type != 'object') return;
//     var pos = name.lastIndexOf('.scope');
//     if (pos == -1) return;
//     if (pos != (name.length - '.scope'.length)) return;
//     return "...(some useful text describing the object)...";
//   });
//
//   var o = { ... };
//   debug.addKnown("Some_special_object_that_we_can_give_a_useful_name",o);
//
// FIXME:
//  - could produce a stack-backtrace, by making use of the "<function_name>.caller",
//    "<function_name>.name" and "<function_name>.arity" properties.
//    Note that this may only work in Firefox... if so, could use <function_name>.toString()
//    then grab the arguments.
//
//  - support FF's lineNumber stuff for exception-printing.
//
//  - rather than do a "show_base_class" thing... we should be using "this.hasOwnProperty(method)
//    to determine this current objects' methods.
//
//  - this.xxx .... probably should fix debug.js to use propertyIsEnumerable
//
//  - could detect Firebug, say with "document.getElementById('_firebugConsole')" so that
//    we can hook into it, maybe set breakpoints...
//
// Notes:
//
//  - We detect if there is a "get()" or "getValue()" method... if so, we call it.
//    We need to make sure it doesn't take any arguments. Note that its not like
//    Java where we can determine the return type, where if it is "void" then
//    its not a getter.
//
(function(W,D,N) {
  var ie5  = (!W.opera && N.userAgent.indexOf("MSIE 5.0") != -1) ? 5 : 0;
  var ie55 = (!W.opera && N.userAgent.indexOf("MSIE 5.5") != -1) ? 5.5 : 0;
  var ie6  = (!W.opera && N.userAgent.indexOf("MSIE 6.0") != -1) ? 6 : 0;
  var ie7  = (!W.opera && N.userAgent.indexOf("MSIE 7.0") != -1) ? 7 : 0;
  var ie8  = (!W.opera && N.userAgent.indexOf("MSIE 8.0") != -1) ? 8 : 0;
  var isIE = ie8 || ie7 || ie6 || ie55 || ie5;
  var ff20 = (N.userAgent.indexOf("Firefox/2.0") != -1) ? 2.0 : 0;
  var ff30 = (N.userAgent.indexOf("Firefox/3.0") != -1) ? 2.0 : 0;
  var isFF = ff20 || ff30;
  var isMac = (N.userAgent.indexOf("Mac") != -1);
  var __last__ = null;

  // User configurable settings
  var config = {
    disable : 0,
    show_extra_info : 0,         // display some extra statistics
    open_window : 0,             // open the console window, on page load
    focus : 0,                   // disable this to stop the popup from stealing focus
    max_elements : 10000,
    buffered_output : 1,
    max_buffered_attempts : 2,   // with big objects, max_elements is exceeded -> this acts as a multiplier
    max_depth : 10,
    max_string_length : 50,
    reset_seen : 1,
    show_argument_index : 1,
    show_type : 1,
    show_nulls : 1,              // We always show 'null' or 'undefined' if we are at depth == 1
    show_undefined : 1,          // else if any recursion -> these options avoid dumping useless attributes.
    show_private_members : 1,    // aka. hidden members, ie: members with a leading underscore
    show_double_private_members : 0, // aka. hidden members, ie: members with a double-leading underscore
    show_functions : 1,
    show_function_bodies : 1,    // Enabling function bodies, will also show function arguments
    show_function_arguments : 1,
    show_function_functions : 1, // Functions attached to other functions, can be disabled.
    show_function_extensions: 0, // Dont dump function extensions
    show_dom_nodes: 0,           // Dont dump DOM nodes
    show_array_extensions: 0,    // Dont dump array extensions
    show_array_members : 1,
    show_toString_function : 0,
    show_runtime_objects : 0,    // ie: the javascript runtime, aka "constructor" and "prototype"
    show_class_name : 1,         // the "CLASSNAME" member can be hidden
    class_name_name : 'CLASSNAME',
    show_base_class : 1,         // drill into the base-class
    base_class_name : 'SUPER',   // the name of the accessor for the base class (eg: you can change this to "SUPER")
    use_horizontal_rule : 1,
    auto_scroll : 0,             // Auto-scroll to the bottom of the output.
    dump_global_objects : 0,     // Should we dump Window, Document, Navigator ?
    skip_types : [               // Comment out the types you need to dump
//      'HTMLBodyElement',
//      'HTMLDivElement',
//      'HTMLSpanElement',
//      'Text',
       __last__
    ],
    skip_relatives : {  // Comment out the children you need to dump
      '.previousSibling' : 'previous sibling',
      '.previousElementSibling' : 'previous element sibling',
      '.nextSibling' : 'next sibling',
      '.nextElementSibling' : 'next element sibling',
      '.parentNode' : 'parent node',
      '.attributes' : 'attributes',
      '.labels' : 'labels',
//      '.style' : 'style',
      __last__ : __last__
    },
    function_extensions : [ 'funcName','argNames','bind','defer' ],
    array_extensions : [ 'every','filter','forEach','indexOf','lastIndexOf','map','reduce','reduceRight','some','reduce','reduceRight','remove','fill','insert','equals' ],
    // FIXME: should split out XML vs HTML attributes
    dom_node : [
      'addBinding','addEventListener','adoptNode','appendChild','appendData','contains','createAttribute','createAttributeNS','createCDATASection','createComment','createDocument','createDocumentFragment','createDocumentType','createElement','createElementNS','createEntityReference','createEvent','createExpression','createNodeIterator','createNSResolver','createProcessingInstruction','createRange','createTextNode','createTreeWalker','cloneNode','compareDocumentPosition','deleteData','dispatchEvent','elementFromPoint','enableStyleSheetsForSet','evaluate','evaluateFIXptr','evaluateXPointer','getAnonymousElementByAttribute','getAnonymousNodes','getAttribute','getAttributeNS','getAttributeNode','getAttributeNodeNS','getBindingParent','getBoundingClientRect','getBoxObjectFor','getClientRects','getElementById','getElementsByClassName','getElementsByTagName','getElementsByTagNameNS','getFeature','getInterface','getUserData','getNamedItem','getNamedItemNS','hasAttribute','hasAttributeNS','hasAttributes','hasChildNodes','hasFeature','hasFocus','importNode','insertBefore','insertData','isDefaultNamespace','isEqualNode','isSameNode','isSupported','item','load','loadBindingDocument','lookupNamespaceURI','lookupPrefix','normalize','normalizeDocument','removeAttribute','removeAttributeNS','removeAttributeNode','removeAttributeNodeNS','removeBinding','removeChild','removeEventListener','removeNamedItem','removeNamedItemNS','renameNode','replaceChild','replaceData','setAttribute','setAttributeNS','setAttributeNode','setAttributeNodeNS','setNamedItem','setNamedItemNS','setUserData','schemaTypeInfo','splitText','substringData',
      'ATTRIBUTE_NODE','CDATA_SECTION_NODE','COMMENT_NODE','DOCUMENT_FRAGMENT_NODE','DOCUMENT_NODE','DOCUMENT_NODE_TYPE','DOCUMENT_POSITION_CONTAINED_BY','DOCUMENT_POSITION_CONTAINS','DOCUMENT_POSITION_DISCONNECTED','DOCUMENT_POSITION_FOLLOWING','DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC','DOCUMENT_POSITION_PRECEDING','DOCUMENT_TYPE_NODE','ELEMENT_NODE','ENTITY_NODE','ENTITY_REFERENCE_NODE','NOTATION_NODE','PROCESSING_NODE','PROCESSING_INSTRUCTION_NODE','TEXT_NODE',
      'nextSibling','previousSibling','ownerDocument',
      __last__ ],
    dom_node_type : [ 'HTMLBodyElement','HTMLDivElement','HTMLSpanElement','Text','XMLDocument','Element' ],
    dump_this_module : 0
  };

  // Internal properties
  var properties = {
    win : null,
    progress : null,
    displayarea : null,
    arg_count : 0,
    call_count : 0,
    element_count : 0,
    buffered_count : 0,
    depth : 0,
    seen : [],
    _break : 0,
    output_buffer : [],
    arg : "arg",
    name : "debug",
    title : "Debug",
    dumpHandlers : [],
    knownObjects : [],
    lastAttribute : null,
    xhtml : !!(D.documentElement && D.documentElement.namespaceURI),
    br : "<br>",
    hr : "<hr>",
    skip_attributes : {
      '.attributes'                           : { skip : ie6, message : "MSIE 6 croaks..." },
      '.filters'                              : { skip : ie6, message : "MSIE 6 croaks..." },
      '.clientInformation.mimeTypes'          : { skip : ie6 || ie7, message : "MSIE 6/7 croaks..." },
      '.clientInformation.opsProfile'         : { skip : ie6 || ie7, message : "MSIE 6/7 croaks..." },
      '.clientInformation.plugins'            : { skip : ie6 || ie7, message : "MSIE 6/7 croaks..." },
      '.clientInformation.userLanguage'       : { skip : ie6 || ie7, message : "MSIE 6/7 croaks..." },
      '.clientInformation.userProfile'        : { skip : ie6, message : "MSIE 6 croaks..." },
      'navigator.mimeTypes'                   : { skip : ie7, message : "MSIE 7 croaks..." },
      'navigator.plugins'                     : { skip : ie7, message : "MSIE 7 croaks..." },
      '.external'                             : { skip : ie6 || ie7, message : "MSIE 7 croaks..." },
      '.selection.typeDetail'                 : { skip : ie7, message : "MSIE 7 croaks..." },
      '.schemaTypeInfo'                       : { skip : ff30, message : "Firefox 3 croaks..." },
      '.activeElement'                        : { skip : ff30, message : "Firefox 3 croaks..." },
      '.domConfig'                            : { skip : ff30, message : "Firefox 3 croaks..." },
      'XMLHttpRequest.channel'                : { skip : ff30, message : "Firefox 3 croaks..." },
      __last__ : __last__
    }
  };
  if (properties.xhtml) {
    properties.br = "<br />";
    properties.hr = "<hr />";
  }
  while (W[properties.name]) {
    properties.name += "_";
  }

  var _ref = function(v) {
    if (typeof(v) == 'undefined') return 'undefined';
    if (v == null) return 'null';
    var t = typeof(v);
    if (t != 'object' && t != 'function') return t;
    if (!v.constructor) return (t == "object") ? "unknown" : t;
    if (v.constructor == Number) return 'number';
    if (v.constructor == String) return 'string';
    if (v.constructor == Array) return 'array';
    if (v.constructor == Date) return 'date';
    if (v.constructor == Boolean) return 'boolean';
    if (v.constructor == RegExp) return 'regexp';
    if (v.constructor == Function) return 'function';
    if (v.constructor == Error) return 'error';
    if (v instanceof Error) return 'error';
    return t;
  };

  var _alltrim = function(s) {
    return s.replace(/^\s*(\S*(\s+\S+)*)\s*$/,"$1");
  };

  var _entitify = function(s) {
    return s.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;");
  };

  var _htmlise = function(s) {
    return _entitify(s).replace(/\n/g,properties.br+"\n&nbsp;").replace(/ /g,"&nbsp;").replace(/\t/g,"&nbsp;&nbsp;&nbsp;&nbsp;");
  };

  var _isInteger = function(arg) {
    var r = _ref(arg);
    if (r == "number") {
      if (isNaN(arg)) return false;
      var s = String(arg);
      if (!s.length) return false;
      if (s.indexOf('.') == -1) return true;
    } else if (r == "string") {
      var l = arg.length;
      if (!l) return false;
      for (var i = 0; i < l; ++i) {
        var c = arg.charAt(i);
        if (c < '0' || c > '9') return false;
      }
      return true;
    }
    return false;
  };

  var _replicate = function(s,no) {
    var t = "";
    for (var i = 0; i < no; ++i) t += String(s);
    return t
  };

  var _endsWith = function(s,ending) {
    var pos = s.lastIndexOf(ending);
    if (pos == -1) return false;
    if (pos == (s.length - ending.length)) return true;
    return false;
  };

  var _caseInsensitiveSorter = function(a,b) {
    if (b == null || typeof(b) == "undefined") return -1;
    if (a == null || typeof(a) == "undefined") return 1;
    var aa = a.toLowerCase();
    var bb = b.toLowerCase();
    if (aa < bb) return -1;
    if (aa > bb) return 1;
    return 0;
  };

  var _open = function() {
    var target = W.opera ? '#' : '';
    var title = properties.title;
    if (W.location.protocol.indexOf('http') != -1) title += "file";
    var props = 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes';
    props += ",height="+parseInt(screen.height*0.6,10)+",width="+parseInt(screen.width/3,10);
    properties.win = W.open(target,title,props);
    if (properties.win && !properties.win.opener) properties.win.opener = W;
    return properties.win;
  };

  var _getElementsByTagName = function(d,name) {
    var ns = 'http://www.w3.org/1999/xhtml';
    if (d.getElementsByTagNameNS) return d.getElementsByTagNameNS(ns,name);
    if (d.getElementsByTagName) return d.getElementsByTagName(name);
    return [];
  };

  var _createElement = function(d,name) {
    var ns = 'http://www.w3.org/1999/xhtml';
    if (d.createElementNS) return d.createElementNS(ns,name);
    if (d.createNode) return d.createNode(1,name,ns);
    var e = d.createElement ? d.createElement(name) : null;
    if (e && e.setAttribute) e.setAttribute("xmlns",ns);
    return e;
  };

  var _init = function() {
    if (!properties.win || properties.win.closed) _open();
    if (!properties.win) return false;
    if (config.autofocus && properties.win.focus) properties.win.focus();
    var doc = properties.win.document;
    if (!doc || !doc.getElementById) return false;
    var da = doc.getElementById('displayarea');
    if (!da) {
      var autoscroll = config.autoscroll ? "checked" : "";
      var progress;
      if (properties.xhtml) {
        var html = doc.documentElement;
        var title = _getElementsByTagName(html,'title')[0];
        if (title) title.text = properties.title;
        var body = _getElementsByTagName(html,'body')[0];
        if (!body) return false;
        body.style.margin = "2px 2px 0px 2px";
        var clear = _createElement(doc,'input');
        if (clear) {
          clear.type = 'button';
          clear.value = "Clear";
          clear.opener = W;
          clear.onclick = function() {
            if (this.opener) properties.call_count = 0;
            var da = this.ownerDocument.getElementById('displayarea');
            da.style.display = "none";
            da.innerHTML = '';
            da.style.display = "";
          };
          body.appendChild(clear);
        }
        var rule = _createElement(doc,'input');
        if (rule) {
          rule.type = 'button';
          rule.value = "Rule Line";
          rule.onclick = function() {
            var da = this.ownerDocument.getElementById('displayarea');
            var l = _createElement(this.ownerDocument,'hr');
            if (da && l) {
              l.width = "100%";
              da.appendChild(l);
            }
          };
          body.appendChild(rule);
        }
        progress = _createElement(doc,'div');
        if (progress) {
          progress.id = "progress";
          body.appendChild(progress);
        }
        var line = _createElement(doc,'hr');
        if (line) {
          line.width = "100%";
          body.appendChild(line);
        }
        da = _createElement(doc,'div');
        if (da) {
          da.id = 'displayarea';
          body.appendChild(da);
        }
      } else {
        doc.writeln("" +
          "<html>\n" +
          "  <head>\n" +
          "    <style type='text/css' media='screen'>\n" +
          "    body { margin: 2px 2px 0px 2px; }\n" +
          "    .stayput { position:fixed; top:0px; z-index:20; width: 100%; background:#cccccc; }\n" +
		  "    .displayarea { position:relative; margin-top: 50px; width: 100%; }\n" +
          "    </style>\n" +
          "    <title>"+properties.title+"</title>\n" +
          "    <script type='text/javascript'>\n" +
          "      function clearFrame() {\n" +
          "        if (window.opener && window.opener."+properties.name+" && window.opener."+properties.name+".reset) window.opener."+properties.name+".reset();\n" +
          "        var div = document.getElementById('displayarea');\n" +
          "        div.style.display = 'none';\n" +
          "        div.innerHTML = '';\n" +
          "        div.style.display = '';\n" +
          "      };\n" +
          "      function ruleLine() {\n" +
          "        var div = document.getElementById('displayarea');\n" +
          "        div.innerHTML += '<hr>';\n" +
          "      };\n" +
          "      function autoScroll() {\n" +
          "        window.opener."+properties.name+".autoScroll();\n" +
          "      };\n" +
          "    </script>\n" +
          "  </head>\n" +
          "  <body>\n" +
          "    <div class='stayput'>\n" +
          "      <input type='button' value='Clear output' onclick='clearFrame();' />" +
          "      <input type='button' value='Rule Line' onclick='ruleLine();' />" +
          "      <input type='button' value='Auto-scroll' onclick='autoScroll();' />" +
          "      <div id='progress' style='float:right; clear:right;'></div>\n" +
          "      <br>\n" +
          "      <hr>\n" +
          "    </div>\n" +
          "    <div id='displayarea' class='displayarea' width='100%' height='100%'></div>\n" +
          "  <a name='#bottom'></a>\n" +
          "  </body>\n" +
          "</html>\n"
        );
        doc.close();
        progress = doc.getElementById('progress');
        da = doc.getElementById('displayarea');
      }
      properties.progress = progress;
    }
    properties.displayarea = da;
    if (!da) return false;
    properties.depth = 0;
    properties.element_count = 0;
    properties.buffered_count = 0;
    if (config.dump_global_objects) properties.seen = [];
    else properties.seen = [ [W,"Window"], [N,"Navigator"], [D,"Document"] ];
    if (! config.dump_this_module) properties.seen.push([this,"Window."+properties.name]);
    if (W.jQuery) {
      properties.seen.push([jQuery.noop,"jQuery.noop"]);
      if (jQuery.fn.noop) properties.seen.push([jQuery.fn.noop,"jQuery.fn.noop"]);
    }
    for (var i = 0, ko = properties.knownObjects, l = ko.length; i < l; ++i) properties.seen.push(ko[i]);
    return true;
  };

  var _print = function(html) {
    var da = properties.displayarea;
    if (!da) alert(properties.name+":"+html);
//    else if (properties.xhtml) return alert("FIXME: XHTML is not yet supported");
    else {
      da.innerHTML += html;
      if (config.auto_scroll) properties.win.scrollTo(0,100000);
    }
    return true;
  };

  var flush = function() {
    if (properties.output_buffer.length) {
      if (config.buffered_output) {
        var p = properties.progress;
        if (p) p.innerHTML = "";
        _print(properties.output_buffer.join(''));
      }
      properties.output_buffer = [];
    }
    return true;
  };

  var reset = function() {
    return (properties.call_count = 0);
  };

  var autoScroll = function() {
    config.auto_scroll = !config.auto_scroll;
    if (config.auto_scroll) properties.win.scrollTo(0,100000);
    return config.auto_scroll;
  };

  var print = function(html) {
    html += "\n";
    if (config.buffered_output) {
      var p = properties.progress;
      if (!properties.buffered_count && p) {
        if (p.innerHTML == ".....") p.innerHTML = "";
        else p.innerHTML += ".";
      }
      properties.output_buffer.push(html);
    } else return _print(html);
    return true;
  };

  var print_ln = function(html) {
    return print(html + properties.br);
  };

  var print_hr = function() {
    return print(properties.hr);
  };

  var print_separator = function(length) {
    length = length ? length : 20;
    return print_ln(_replicate("-",length));
  };

  var _printValue = function(name,type,value,info) {
    properties.element_count ++;
    if (!name) name="";
    if (!type) type="";
    else if (config.show_type) type=" &lt;"+type+"&gt;";
    else type = "";
    if (value == null || typeof(value) == "undefined") value="";
    else {
      value = ""+value;
      value = _htmlise(value);
      if (name.length || type.length) value = " = "+value;
    }
    if (!info) info = "";
    else info = " " + _htmlise(info);
    var s = name+type+value+info;
    if (!s.length) s = "(no information)";
    if (config.show_argument_index) s = properties.arg_count+"| "+s;
    s += properties.br;
    return print(s);
  };

  var _printDumpFailure = function(name,arg,mode) {
    var msg = "...(some form of failure "+ (mode ? " - dumping "+mode : "") +")";
    if (properties._break) msg = "...(break)";
    else if (properties.element_count >= config.max_elements) msg = "...(max elements)";
    var type = _ref(arg);
    _printValue(name,type,msg);
  };

  var _printException = function(name,type,ex) {
//FIXME: support FF's lineNumber stuff...
//    var info = ex.lineNumber ? "" : ex.fileName+":"+ex.lineNumber;
    var info = "";
    return _printValue(name,type,"... (Exception: "+ex+")",info);
  };

  var _getNameFromConstructor = function(arg) {
    var name;
    var s = _alltrim(String(arg.constructor));
    if(s.substr(0,1) == '[' && s.substr(s.length-1,1) == ']') {
      name = s.substring(1,s.length-1);
      var lc = name.toLowerCase();
      if (lc.indexOf("object") == 0) name = name.substring("object".length+1);
      else if (lc.indexOf("class") == 0) name = name.substring("class".length+1);
      name = name.replace(/^\s*/,"").replace(/\s*$/,"");
      lc = name.toLowerCase();
      if (lc == "object") name = null;
    }
    return name;
  };

  var _hasMembers = function(o) {
    for (var m in o) {
      if (m == "prototype" || m == "constructor" || m == "toString") continue;
      if (m == config.class_name_name && !config.show_class_name) continue;
      if (typeof(o[m]) == "function" && !config.show_function_functions) continue;
      return true;
    }
    return false;
  };

  var _maxDepthReached = function(arg,name,type) {
    if (!_hasMembers(arg)) return false;
    if (properties.depth > config.max_depth) {
      var t = _getNameFromConstructor(arg);
      if (!t) t = type;
      _printValue(name,type,"... (max depth hit when traversing '"+t+"')");
      return true;
    }
    return false;
  };

  var _seen = function(arg) {
    for (var item, i = 0, s = properties.seen, l = s.length; i < l; ++i){
      item = s[i];
      try { if (arg === item[0]) return item; } catch(e) { print_ln(properties.name+"._seen() failure: "+e); }
    }
  };

  var _skipType = function(name) {
    for (var i = 0, sk = config.skip_types, l = sk.length - 1; i < l; ++i) {
      if (name == sk[i]) return true;
    }
    return false;
  };

  var _skipRelative = function(name,type) {
    var sk = config.skip_relatives;
    for (var i in sk) {
      if (_endsWith(name,i)) {
        _printValue(name,type,"...("+sk[i]+" skipped)");
        return true;
      }
    }
    return false;
  };

  var _skipAttribute = function(name,type) {
    var sk = properties.skip_attributes;
    for (var i in sk) {
      if (_endsWith(name,i)) {
        var do_skip = false;
        if (typeof(sk[i].skip) == 'function') {
          if (sk[i].skip()) do_skip = true;
        } else if (sk[i].skip) do_skip = true;
        if (do_skip) {
          if (sk[i].message) _printValue(name,type,"...(skipped attribute)",sk[i].message);
          else _printValue(name,type,"...(skipped attribute)");
          return true;
        }
      }
    }
    return false;
  };

  var _indexOf = function (array,item,from,to) {
    to = +to || array.length;
    from = +from || 0;
    from = (from < 0) ? Math.ceil(from) : Math.floor(from);
    if (from < 0) from += to;
    for (; from < to; ++from) {
      if (array[from] === item) return from;
    }
    return -1;
  };

  var _isDomNode = function(name) {
    for (var i = 0, l = config.dom_node_type.length; i < l; ++i) {
      var t = config.dom_node_type[i];
      if (name.substr(0,t.length) == t) return true;
    }
    return false;
  };

  var _isGetter = function(obj,item) {
    if (item.substr(0,3) != "get") return false;
    if (_ref(obj[item]) != 'function') return false;
    var s = obj[item].toString(), pos = s.indexOf("(");
    // makes sure that getter takes no arguments
    if (s.substr(pos+1,1) != ")") return false;
    // dont execute the browser getters.
    if (s.indexOf("[native code]") != -1) return false;
    return true;
  };

  var _dumpValue = function(arg,name) {
    if (name == null || typeof(name) == "undefined") name = null;
    if (name == null) throw "Found unnamed arg";
    if (properties._break) return false;
    if (properties.element_count+1 > config.max_elements) {
      if (config.buffered_output) {
        properties.buffered_count++;
        if (properties.buffered_count < config.max_buffered_attempts) {
          flush();
          // FIXME: make this a timeout (using Date.now()), to determine
          //        how much time has actually elapsed.
          var ok = confirm(properties.name+"() is taking quite some time to execute.\nClick cancel to abort debugging (current pass: "+(properties.buffered_count+1)+").\nClick ok to continue debugging.");
          if (!ok) {
            properties._break = true;
            return false;
          }
          properties.element_count = 0;
        } else return false;
      } else return false;
    }
    var type = _ref(arg);
    if (properties.dumpHandlers.length) {
      for (var i = 0, dh = properties.dumpHandlers, l = dh.length; i < l; ++i) {
        var f = dh[i];
        var result = f(arg,name,type);
        if (result == null) continue;
        if (result !== false) _printValue(name,type,result);
        return true;
      }
    }
    if (type == "object" || type == "array" || type == "function" || type == "error" || (!isIE && type == "string" && arg.length > config.max_string_length)) {
      var seen = _seen(arg), prefix = "Arg[", suffix = "].";
      if (seen) {
        var s = ""+seen[1];
        if (config.show_argument_index) {
          var pos = s.indexOf(suffix), ac = parseInt(s.substring(prefix.length,pos),10);
          if (ac == properties.arg_count) s = s.substring(pos+suffix.length);
        }
        _printValue(name,type,undefined,"=== "+s);
        return true;
      }
      var n = ""+name;
      if (config.show_argument_index) n = prefix+properties.arg_count+suffix+n;
      if (type == "string") properties.seen.push([arg.toString(),n]);
      else properties.seen.push([arg,n]);
    }
    var ret = true;
    properties.depth ++;
    if (name.indexOf(properties.arg) == 0) name = null;
    try {
      switch (type) {
        case 'unknown':
          if (name == null) name = "...";
          _printValue(name,type,"... (unknown contents - possibly a native object)");
          break;
        case 'null':
          if (properties.depth == 1 || config.show_nulls) _printValue(name,type);
          break;
        case 'undefined':
          if (properties.depth == 1 || config.show_undefined) _printValue(name,type);
          break;
        case 'function': // fall though to 'object' (kindly skips through 'error')
          if (name == null) {
            if (arg === W[properties.name]) name = properties.name; // Detect when point at itself...!
            else if (arg[config.class_name_name] && arg[config.class_name_name] != "Object") name = arg[config.class_name_name]; //"class{"+arg[config.class_name_name]+"}";
            else {
              var constructor = _getNameFromConstructor(arg);
              if (constructor) name = constructor;
              else if (properties.depth == 1) {
                if (_hasMembers(arg)) {
                  if (arg === Number) name = "Number";
                  else if (arg === String) name = "String";
                  else if (arg === Array) name = "Array";
                  else if (arg === Date) name = "Date";
                  else if (arg === Boolean) name = "Boolean";
                  else if (arg === RegExp) name = "RegExp";
                  else if (arg === Function) name = "Function";
                  else if (arg === Error) name = "Error";
                  else if (arg === Object) name = "Object";
                }
              }
            }
            if (name == null) {
              name = ""+arg;
              name = name.substring(name.indexOf(" ")+1);
              name = name.substring(0,name.indexOf(" "));
              name = name.substr(0,name.indexOf("("));
              if (name.substr(0,1) == "{") name = "";
              else if (name.substr(0,1) == "(") name = "";
              else if (name.indexOf("Function") == 0) name = "";
              else if (name.indexOf("Object") == 0) name = "";
            }
          }
          if (name.indexOf("HTML") == 0) type = "object";
          else {
            if (arg[config.class_name_name] && arg[config.class_name_name] != 'Object' && arg.toString().match(/class/)) {
              var base = (arg.prototype && arg.prototype[config.base_class_name]) ? arg.prototype[config.base_class_name][config.class_name_name] : null;
              if (base) base = "extends <class:"+base+">";
              _printValue(name,"class:"+arg[config.class_name_name],null,base);
            } else if (config.show_functions) {
              if (!config.show_toString_function && name.replace(/.*\./,"") == "toString") break;
              if (!config.show_private_members && name.replace(/.*\./,"").substr(0,1) == '_') break;
              if (!config.show_double_private_members && name.replace(/.*\./,"").substr(0,2) == '__') break;
              if (config.show_function_bodies) {
                var body = arg.toString();
                var body = _alltrim(body);
                //var body = _alltrim(arg.toString());
                if (properties.depth != 1) body = "function()"+body.substr(body.indexOf("{"));
                if (body.match(/\[native code\]/)) {
                  body = body.replace(/ |\t|\n/g,"").replace(/nativecode/,"native code").replace(/Function|Object/,"").replace(/^function/,"function ");
                } else body = body.replace(/;([^\n])/g,"; $1").replace(/\{([^\s+])/mg,"{ $1");
                _printValue(name,null,body);
              } else if (config.show_function_arguments) {
                var s = _alltrim(arg.toString());
                var args = s.substring(s.indexOf("(")+1,s.indexOf(")"));
                args = args.replace(/ /g,"");
                var body = s.substring(s.indexOf(")")+1);
                body = body.replace(/ |\t|\n/g,"");
                if (body != "{}") {
                  if (body == "{[nativecode]}") body = "{[native code]}";
                  else body = "{...}";
                }
                s = "function("+args+")"+body;
                _printValue(name,null,s);
              } else {
                 _printValue(name,null,"function(){...}");
              }
            }
            // Sometimes functions contain other properties, so we optionally allow
            // the 'object' dumper to dump the function.
            if (!_hasMembers(arg)) break;
          }
        case 'error': // fall though to 'object'
          if (name == null) {
            name = "exception";
            if (arg.name) name += "{"+arg.name+"}";
            else if (arg[config.class_name_name]) name += "{"+arg[config.class_name_name]+"}";
          }
        case 'object':
          var constructor = _getNameFromConstructor(arg);
          if (name == null) {
            if (arg[config.class_name_name] && arg[config.class_name_name] != "Object") name = "object"; //arg[config.class_name_name]; //"object{"+arg[config.class_name_name]+"}";
            else if (constructor && constructor.indexOf("class") == -1) name = constructor;
            else if (_hasMembers(arg)) name = type;
            else name = "";
          }
          if (_maxDepthReached(arg,name,type)) break;
          else if (type == "object") {
            if (arg[config.base_class_name] && arg[config.base_class_name][config.class_name_name]) {
              if (type.indexOf(":") == -1 && arg[config.class_name_name] && arg[config.class_name_name] != "Object") type += ":"+arg[config.class_name_name];
              _printValue(name,type,null,"extends <class:"+arg[config.base_class_name][config.class_name_name]+">");
            } else {
              if (constructor) {
                type += ":"+constructor;
                if (_skipType(constructor)) {
                  _printValue(name,type,"...(skipped - too big to dump)");
                  break;
                }
              } else {
              }
              if (type.indexOf(":") == -1 && arg[config.class_name_name] && arg[config.class_name_name] != "Object") type += ":"+arg[config.class_name_name];
              if (W.jQuery && properties.depth == 1 && arg instanceof jQuery) {
                name = '$(...)';
                type += ':jQuery';
              }
              _printValue(name,type);
            }
          }
          if (name.indexOf("HTMLEmbed") == 0) { // Handle Java-embedded objects
            break;
          }
          var a = [];
          var b = [];
// FIXME: move getter code into 'function' block
          var getters = {};
          var length_member = false;
          for (var i in arg) {
            if (!config.show_runtime_objects && (i == "constructor" || i == "prototype")) continue;
            if (!config.show_class_name && i == config.class_name_name) continue;
            if (!config.show_toString_function && i == "toString") continue;
            if (!config.show_private_members && i.substr(0,1) == '_') continue;
            if (!config.show_double_private_members && i.substr(0,2) == '__') continue;
            if (!config.show_base_class && i == config.base_class_name) continue;
            if (!config.show_function_extensions && _indexOf(config.function_extensions,i) != -1) continue;
            if (!config.show_dom_nodes && _indexOf(config.dom_node,i,0,config.dom_node.length-1) != -1 && _isDomNode(name)) continue;
            if (i == "length") { length_member = true; continue; }
            if (_isInteger(i)) b.push(i);
            else a.push(i);
            if (_isGetter(arg,i)) getters[i] = 1;
          }
          if (typeof(arg.length) == 'number' && arg.length > 0) length_member = true;
          if (length_member && typeof(arg.length) == 'number') {
            if (!b.length) {
              for (var i = 0, l = arg.length; i < l; ++i) {
                var r = _ref(arg[i]);
                if (r != 'null' && r != 'undefined') b.push(i);
              }
              length_member = false;
            }
          }
          if (length_member && !b.length) a.push("length");
          a.sort(_caseInsensitiveSorter);
          for (var i = 0, l = a.length; i < l; ++i) {
            if (_skipRelative(name+"."+a[i],type)) continue;
            if (_skipAttribute(name+"."+a[i],type)) continue;
            properties.lastAttribute = name + "." + a[i];
            if (a[i] in getters) {
              try {
                _dumpValue(arg[a[i]](),name+"."+a[i]+"()");
              } catch(e) {}
            }
              try {
                if (!_dumpValue(arg[a[i]],name + "." + a[i])) {
                  _printDumpFailure(name + "." + a[i],arg[a[i]],"object/key");
                  ret = false;
                  continue;
                }
              } catch(e) {
                _printException(name + "." + a[i],_ref(arg[a[i]]),e);
              }
          }
          for (var i = 0, l = b.length; i < l; ++i) {
            if (!_dumpValue(arg[b[i]],name + "[" + b[i] + "]")) {
              _printDumpFailure(name + "[" + b[i] + "]",arg[b[i]],"object/index");
              ret = false;
              continue;
            }
            a.push(i);
          }
  // FIXME: should we have this code?
  //        if (a.length == 0) {
  //          if (config.show_type) _printValue(name,null,"... (empty)");
  //          else _printValue(name,null,"... (empty for '"+type+"')");
  //        }
          break;
        case 'array':
          var constructor = _getNameFromConstructor(arg);
          if (name == null) {
            if (arg[config.class_name_name] && arg[config.class_name_name] != "Array") name = "array{"+arg[config.class_name_name]+"}";
            else if (constructor) name = constructor;
            else if (_hasMembers(arg)) name = type;
            else name = "";
          }
          if (_maxDepthReached(arg,name,type)) break;
          else if (arg[config.base_class_name] && arg[config.base_class_name][config.class_name_name]) _printValue(name,type,null,"extends <class:"+arg[config.base_class_name][config.class_name_name]+"> :: length = "+arg.length);
          else _printValue(name,type,null,":: length = "+arg.length);
          var a = [];
          var b = [];
          for (var i in arg) {
            if (i == 'length') continue;
            if (!config.show_runtime_objects && (i == "constructor" || i == "prototype")) continue;
            if (!config.show_class_name && i == config.class_name_name) continue;
            if (!config.show_private_members && i.substr(0,1) == '_') continue;
            if (!config.show_double_private_members && i.substr(0,2) == '__') continue;
            if (!config.show_array_extensions && _indexOf(config.array_extensions,i) != -1) continue;
            if (!_isInteger(i)) a.push(i);
          }
          for (var i = 0, l = arg.length; i < l; ++i) {
            if (!_dumpValue(arg[i],name + "[" + i + "]")) {
              _printDumpFailure(name + "[" + i + "]",arg[i],"array/index");
              ret = false;
              continue;
            }
            b.push(i);
          }
          if (config.show_array_members) {
            a.sort(_caseInsensitiveSorter);
            for (var i = 0, l = a.length; i < l; ++i) {
              if (Array.prototype[a[i]]) continue;
              try {
                if (!_dumpValue(arg[a[i]],name + "." + a[i])) {
                  _printDumpFailure(name + "." + a[i],arg[a[i]],"array/key");
                  ret = false;
                  continue;
                }
              } catch(e) {
                _printException(name + "." + a[i],_ref(arg[a[i]]),e);
              }
              b.push(a[i]);
            }
         }
  // FIXME: should we have this code?
  //        if (b.length == 0) {
  //          if (config.show_type) _printValue(name,null,"... (empty)");
  //          else _printValue(name,null,"... (empty for '"+type+"')");
  //        }
          break;
//FIXME rework these so that they fall through to 'object' when they are actually objects,
//      so that we get their attributes.
        case 'date':
          var tm = arg.getTime();
          if (isNaN(tm)) _printValue(name,type,"Invalid date ["+ tm +"]") ;
          else _printValue(name,type,arg.toString() +" ["+ tm +"]") ;
          break;
        case 'string':
          var sep = "'";
          var s = arg.toString();
          if (s.indexOf("'") == -1) sep = "'";
          else if (s.indexOf('"') == -1) sep = '"';
          else s = s.replace(/'/g,"\\'");
          _printValue(name,type,sep+s+sep);
          break;
        case 'number':
          var s = String(arg);
          if (isNaN(arg)) {
            if (arg == Number.NEGATIVE_INFINITY) _printValue(name,type,'-Infinity');
            else if (arg == Number.POSITIVE_INFINITY) _printValue(name,type,'Infinity');
            else _printValue(name,type,'NaN');
          } else {
            if (s.indexOf('.') != -1) _printValue(name,'float',s);
            else if (arg == Number.NEGATIVE_INFINITY) _printValue(name,type,'-Infinity');
            else if (arg == Number.POSITIVE_INFINITY) _printValue(name,type,'Infinity');
            else _printValue(name,'integer',s);
          }
          break;
        default:
          // ie: RegExp, Boolean, etc
          _printValue(name,type,String(arg));
      }
    } catch(e) {
      if (properties.lastAttribute && properties.lastAttribute.indexOf(name) == 0) print_ln("Exception caught: "+properties.lastAttribute);
      else print_ln("Exception caught on: "+name+" with type: "+type);
      if (e.message || e.description) print_ln("Info : "+(e.message || e.description));
      //_dumpValue(e,"Exception");
    }
    properties.depth --;
    return ret;
  };

  var dump = function() {
    if (config.disable) return;
    if (!_init.apply(dump) && !isMac) return alert("Failed to correctly initialise "+properties.title+" module");
    var ret = dump;
    if (arguments.length) {
      if(config.show_extra_info) {
        print_ln("Arguments: "+arguments.length);
        print_ln("Max depth: "+config.max_depth);
        print_ln("Max elements: "+config.max_elements);
        print_separator();
        flush();
      }
      for (var i = 0, l = arguments.length; i < l; ++i) {
        properties.arg_count = i;
        if (!_dumpValue(arguments[i],properties.arg+"["+i+"]")) break;
        if (config.buffered_output && !properties.output_buffer.length) _printValue(null,null,"... (nothing dumped - try changing the "+properties.title+" configuration variables)");
        flush();
      }
      if(config.show_extra_info) {
        print_separator();
        if (properties.element_count >= config.max_elements) print_ln("Too many elements, total dumped: "+properties.element_count);
        else print_ln("Total elements dumped: "+properties.element_count);
      } else {
        if (properties.element_count >= config.max_elements) print_ln("...");
      }
      if (config.use_horizontal_rule) print_hr();
      flush();
      if (config.reset_seen) properties.seen = [];
    } else {
      print_ln(properties.title+": "+properties.call_count);
      properties.call_count ++;
      flush();
      ret = properties.call_count - 1;
    }
    return ret;
  };

  var addHandler = function(func) {
    properties.dumpHandler.push(func);
  };

  var addKnown = function(name,o) {
    var i = [o,name];
    properties.seen.push(i);
    properties.knownObjects.push(i);
  };

  var skipType = function(name) {
    config.skip_types.push(name);
  };

  // Old-Safari on Mac barfs without this.
  if (config.open_window || isMac) _init.apply(dump);

  // Bind public functions into our namespace.
  dump.config = config;
  dump.init = function() {
    if (config.disable) return;
    if (arguments.callee.done) return;
    arguments.callee.done = true;
    _init.apply(dump);
  };
  dump.print = function(html) {
    if (config.disable) return;
    if (!_init.apply(dump) && !isMac) return alert("Failed to correctly initialise "+properties.title+" module");
    return (print(html) && flush());
  };
  dump.print_ln = function(html) {
    if (config.disable) return;
    if (!_init.apply(dump) && !isMac) return alert("Failed to correctly initialise "+properties.title+" module");
    return (print_ln(html) && flush());
  };
  dump.print_separator = function() {
    if (properties.displayarea) return (print_separator() && flush());
  };
  dump.print_hr = function() {
    if (properties.displayarea) return (print_hr() && flush());
  };
  dump.flush = flush;
  dump.reset = reset;
  dump.autoScroll = autoScroll;
  dump.addHandler = addHandler;
  dump.addKnown = addKnown;
  dump.skipType = skipType;

  if (!W.onerror) W.onerror = function(message,file,line) {
    file = file ? ""+file : "";
    var pos = file.indexOf("?");
    if (pos != -1) file = file.substring(0,pos);
    pos = file.lastIndexOf("/");
    if (pos != -1 && ++pos < file.length) file = file.substr(pos);
    var attr = (file && line) ? file+" (line: "+line+")" : "";
    dump.print("<table width=100%><tr><td width=100%>An error occurred: "+message+"</td><td align=right nowrap>"+attr+"</td></tr></table>");
    dump.print_hr();
    return false;
  };

/*
  // Since some browsers provide extra hooks, we can make use of them.
  if (isFF) Object.prototype.__noSuchMethod__ = function __noSuchMethod__(id,args){
    dump.print_ln("No such method: "+id) && dump.print_hr();
    throw "No such method: "+id;
  };
*/

  // Finally... bind into global namespace.
  W[properties.name] = dump;
  if (W.jQuery) $[properties.name] = dump;

})(window,document,navigator);

