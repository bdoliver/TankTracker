var require = {
    baseUrl: "/static/js",
    shim   : {
 'jquery': { exports: '$' },
        'bootstrap'   : ['jquery'],
        'colpick'     : ['jquery'],
        'jquery.flot' : {
            'deps'    : ['jquery'],
            'exports' : '$.plot'
        },
        'jquery.flot.time' : {
            'deps'    : ['jquery.flot']
        },
        'jquery.flot.navigate' : {
            'deps'    : ['jquery.flot']
        },
        'jquery.flot.resize' : {
            'deps'    : ['jquery.flot']
        }
    },
    paths: {
        "jquery"               : 'lib/jquery-2.1.4.min',
        "bootstrap"            : 'lib/bootstrap.min',
        "bootstrap-datepicker" : 'lib/bootstrap-datepicker.min',
        "bootstrap-dialog"     : 'lib/bootstrap-dialog.min',
        "colpick"              : 'lib/colpick',
        "fileinput"            : 'lib/fileinput.min',
        "jquery.flot"          : 'lib/jquery.flot.min',
        "jquery.flot.navigate" : 'lib/jquery.flot.navigate.min',
        "jquery.flot.resize"   : 'lib/jquery.flot.resize.min',
        "jquery.flot.time"     : 'lib/jquery.flot.time.min',
        "moment"               : 'lib/moment.min',
        "moment-strftime"      : 'lib/moment-strftime-0.1.2.min'
    }
};


