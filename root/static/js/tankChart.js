define(['jquery',
        'bootstrap-datepicker',
        'moment',
        'moment-strftime',
        'jquery.flot',
        'jquery.flot.navigate',
        'jquery.flot.resize',
        'jquery.flot.time'
       ], function ($) {

    function chartTooltip(x, y, contents) {
        $('<div id="tooltip">'+contents+'</div>').css({
            position           : 'absolute',
            display            : 'none',
            top                : y + 5,
            left               : x + 5,
            border             : '1px solid #fdd',
            padding            : '2px',
            'background-color' : '#fee',
            opacity            : 0.80
        }).appendTo("body").fadeIn(200);
    }

    function get_request_data() {
        var ret = false;
        var msg;
        var request_data = {};

        // in order to chart, we need either start or end date...
        if ( $('#sdate').val() || $('#edate').val() ) {
            request_data['sdate'] = $('#sdate').val();
            request_data['edate'] = $('#edate').val();
        }
        else {
            msg = 'You must select at least a start or end date value';
        }

        // ... and at least one of the checkboxes:
        var param_ids = [];

        $('input[type="checkbox"][name="parameter_id"]:checked').each(function(idx,obj) {
            // the value of each checkbox represents the ID of the water test
            // parameter selected for charting:
            param_ids.push($(obj).val());
        });

        if ( param_ids.length > 0 ) {
            request_data['parameter_id'] = param_ids;
            ret = request_data;
        }
        else {
            msg = 'You must select at least one result for graphing';
        }

        if ( msg ) {
            $('div#msgChartDiv').html(
                '<p class="text-danger">'+msg+'</p>'
            );
        }

        // does the user want notes included?
        if ( $('#show_notes').is(':checked') ) {
            request_data['show_notes'] = 1;
        }

        return ret;
    }

    function generateChart(tank_id) {

        $('div#msgChartDiv').empty(); // clear any previous message

        var request_data = get_request_data();

        if ( ! request_data ) {
            // insufficient selections to chart
            return false;
        }

        var options = {
            lines:  { show       : true   },
            points: { show       : true   },
            xaxis:  { mode       : 'time',
                      timeformat : "%Y/%m/%d"
                    },
            grid:   { hoverable  : true,
                      clickable  : true,
                      // gradient BG for chart:
                      backgroundColor: { colors: ["#CED8F6",
                                                  "#FFFFFF"] }
                    },
            pan:    { interactive: true,
                      cursor     : 'move', // CSS mouse cursor value used when dragging, e.g. "pointer"
                      frameRate  : 20
                    }
        };

        if ( $('#chart_zoom').is(':checked') ) {
            options['zoom'] = {
                interactive : true,
                trigger     : 'dblclick', // or "click" for single click
                amount      : 1.5         // 2 = 200% (zoom in), 0.5 = 50% (zoom out)
            };
        }

        $.ajax({
             url      : '/tank/'+tank_id+'/water_test/chart/data',
             xhrFields: { withCredentials: true }, // seems to be necessary for catalyst to get the cookie
             data     : request_data,
             dataType : 'json',
             type     : 'POST',
             success  : function(data, status) {
                if ( data.length < 1 ) {
                    $('div#msgChartDiv').html(
                        '<p class="text-danger">'
                       +'No test results available for charting (check your selections).'
                       +'</p>'
                    );
                    return false;
                }

                var yaxes = [];

                // Put each dataset's measurement on its own Y-axis.
                // This permits better scaling when vastly different
                // test results are being charted (eg. Ca ppm vs. pH)
                for ( var i = 1; i <= data.length; i++ ) {
                    yaxes.push({position: 'left'});
                }
                options.yaxes = yaxes;
                var plot = $.plot($('#testChartDiv'), data, options);

                var previousPoint = null;
                $('#testChartDiv').unbind("plothover");
                $('#testChartDiv').bind(
                    "plothover",
                    function (event, pos, item) {
                        if ( item ) {
                            if ( previousPoint != item.dataIndex ) {
                                previousPoint = item.dataIndex;

                                $("#tooltip").remove();
                                var date = moment(item.datapoint[0], 'x').strftime('%Y-%m-%d');
                                var data = item.datapoint[1];
                                var tip  = item.series.label + " on " + date + " : " + data;
                                if ( item.series.data[item.dataIndex][2] ) {
                                    tip += '<p><strong>Note:</strong><br />'
                                           +item.series.data[item.dataIndex][2]
                                           +'</p>';
                                }

                                chartTooltip(item.pageX,
                                             item.pageY,
                                             tip);
                            }
                        }
                        else {
                            $("#tooltip").remove();
                            previousPoint = null;
                        }
                });
                        }, // end 'success' function
             error   :  function( req, textStatus, errorThrown ) {
                var e = "generateChart() AJAX call failed";
                if ( textStatus  ) { e += ": " + textStatus; }
                if ( errorThrown ) { e += " (" + errorThrown + ")"; }
                //e += " req==>"+req.text+"<==";
                alert(e);
                return false;
                        }  // end 'error' function
        }); // end .ajax()
    }

    return {
        setup: function(tank_id) {

            // NB: the boostrap datepicker is applied to the DIVs that contain
            //     the actual input fields, so that clicking the glyphicon will
            //     also trigger the calendar. It also helps with formatting.
            $('#start_date').datepicker({
                format        : 'yyyy-mm-dd',
                clearBtn      : true,
                autoclose     : true,
                endDate       : '+0d'
            });

            $('#end_date').datepicker({
                format        : 'yyyy-mm-dd',
                todayHighlight: true,
                clearBtn      : true,
                autoclose     : true,
                endDate       : '+0d'
            });

            // these are the actual input elements - set up defaults:
            // - start date to one month ago:
            $('#sdate').val(moment().subtract(1, 'month').strftime('%Y-%m-%d'));
            // - end date is today:
            $('#edate').val(moment().strftime('%Y-%m-%d'));

            // reset the chart + selections on button click:
            $('#chart_reset').click(function() {
                $('input[type="checkbox"][name="parameter_id"]').each(function(idx,obj) {
                    $(obj).attr('checked', false);
                });
                $('#sdate').val('');
                $('#edate').val(moment().strftime('%Y-%m-%d'));
                $('#chart_zoom').attr('checked', false);
                $('#show_notes').attr('checked', false);
                $('#testChartDiv').empty();
                $('#msgChartDiv').empty();
            });

            // bind an onChange handler to each chart option checkbox:
            $('input[type="checkbox"][name="parameter_id"]').each(function(idx,obj) {
                $(obj).change( function() { generateChart(tank_id); });
            });
            // ... and the chart_zoom option:
            $('#chart_zoom').change(function() { generateChart(tank_id); });
            // ... and the show_notes option:
            $('#show_notes').change(function() { generateChart(tank_id); });
            // ... and the date pickers:
            $('#sdate').change(function() { generateChart(tank_id); });
            $('#edate').change(function() { generateChart(tank_id); });
        }
    }
});
