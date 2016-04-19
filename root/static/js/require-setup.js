var require = {
    baseUrl: "/static/js",
    shim   : {
        "bootstrap"   : ['jquery'],
        "colpick"     : ['jquery'],
        "jquery.flot" : {
            'deps'    : [ 'jquery' ],
            'exports' : '$.plot'
        }
    },
    paths: {
        "jquery"               : 'jquery-2.1.4.min',
        "bootstrap"            : 'bootstrap.min',
        "bootstrap-datepicker" : 'bootstrap-datepicker.min',
        "bootstrap-dialog"     : 'bootstrap-dialog.min',
        "colpick"              : 'colpick',
        "fileinput"            : 'fileinput.min',
        "jquery.flot"          : 'jquery.flot.min',
        "jquery.flot.navigate" : 'jquery.flot.navigate.min',
        "jquery.flot.resize"   : 'jquery.flot.resize.min',
        "jquery.flot.time"     : 'jquery.flot.time.min',
        "moment"               : 'moment.min',
        "moment-strftime"      : 'moment-strftime-0.1.2.min'
    }
};


