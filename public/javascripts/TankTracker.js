
function setMsg (msg, err) {
    $('#message').empty();
    $('#message').removeClass('msg');
    $('#message').removeClass('err');

    $('#message').addClass(err ? 'err' : 'msg').append(msg);
}

function refreshTankSel (tank_id) {
    $.ajax({async:    true,
            url:      uri_base+'/tank/list',
            data:     { 'tank_id' : tank_id },
            dataType: 'json',
            type:     'GET',
            success:  function(data,status) {
                        if ( ! status || ! data ) {
                            return alert("refreshTankSel() Unexpected AJAX failure: no data or status returned.");
                        }
                        $('#tankSel').empty();
                        $.each(data, function(i, tank) {
                                var opt = "<option value='"
                                          +tank.tank_id
                                          +"' "
                                          +(tank.selected?tank.selected:'')
                                          +">"
                                          +tank.tank_name;
                                if ( tank.water_type ) {
                                    opt += " ("+tank.water_type+")";
                                }
                                opt += "</option>";
                                $('#tankSel').append(opt);
                        });
                      },
            error:    function ( req, textStatus, errorThrown ) {
                        var e = "refreshTankSel() AJAX call failed.";
                        if ( textStatus  ) { e += " " + textStatus; }
                        if ( errorThrown ) { e += " : " + errorThrown; }
                        alert(e);
                        return false;
                      }
    });
}

function saveTank(edit, notesOnly) {

    // if 'edit' is any true value, we are re-saving an existing tank
    // record that has just been edited.
    // if notesOnly is any true value then we only save the 'notes'
    // (causes server-side validation of tank attributes to be bypassed):
    var tank = { 'tankName'     : $('#tankName').val(),
                 'tankType'     : $('#tankType').val(),
                 'tankCapacity' : $('#tankCapacity').val(),
                 'capacityUnit' : $('#capacityUnit').val(),
                 'tankLength'   : $('#tankLength').val(),
                 'tankWidth'    : $('#tankWidth').val(),
                 'tankDepth'    : $('#tankDepth').val(),
                 'dimensionUnit': $('#dimensionUnit').val(),
                 'tank_id'      : $('#tankForm > #tank_id').val(),
                 'notes'        : $('#tankNotes').val(),
                 'notesOnly'    : notesOnly };

    var ret = false;

    $.ajax({async:    false,
            url:      uri_base+(edit ? '/tank' : '/tank/add'),
            data:     tank,
            dataType: 'json',
            type:     'POST',
            success:  function(data,status) {
                        if ( ! status || ! data ) {
                            return alert("Unexpected AJAX failure: no data or status returned.");
                        }
                        if ( data.err ) {
                            return alert(data.err);
                        }
                        if ( data.ok ) {
                            if ( notesOnly ) {
                                // toggle the notes pane back to default status:
                                toggleTankEdit(false);
                            }
                            else {
                                setMsg("Saved tank details ok.");
                                // force the tank list to be refreshed....
                                refreshTankSel(data.tank_id);
                            }
                            ret = data.updated_on;
                            return ret;
                        }
                      },
            error:    function ( req, textStatus, errorThrown ) {
                        var e = "saveTank() AJAX call failed.";
                        if ( textStatus  ) { e += " " + textStatus; }
                        if ( errorThrown ) { e += " : " + errorThrown; }
                        alert(e);
                        return false;
                      }
    });

    return ret;
}

var previousPoint = null;

function chartTooltip(x, y, contents) {
    $('<div id="tooltip">'+contents+'</div>').css({
        position: 'absolute',
        display: 'none',
        top: y + 5,
        left: x + 5,
        border: '1px solid #fdd',
        padding: '2px',
        'background-color': '#fee',
        opacity: 0.80
    }).appendTo("body").fadeIn(200);
}

function generateChart(tank_id) {
    // in order to chart, we need either start or end date
    // and at least one of the checkboxes: 
    if ( ( $('#sdate').val() || $('#edate').val() )
                    &&
         ( $('#chart_ph').is(':checked')         ||
           $('#chart_ammonia').is(':checked')    ||
           $('#chart_nitrite').is(':checked')    ||
           $('#chart_nitrate').is(':checked')    ||
           $('#chart_calcium').is(':checked')    ||
           $('#chart_phosphate').is(':checked')  ||
           $('#chart_magnesium').is(':checked')  ||
           $('#chart_kh').is(':checked')         ||
           $('#chart_alkalinity').is(':checked') ||
           $('#chart_salinity').is(':checked') 
         )
       ) {
        // ok to update chart...
    }
    else {
        // insufficient selections to chart
        return false;
    }

    var options = {
            lines:  { show       : true   },
            points: { show       : true   },
            xaxis:  { mode       : 'time',
                      timeformat : "%Y/%m/%d" },
            grid:   { hoverable  : true,
                      clickable  : true,
                      // gradient BG for chart:
                      backgroundColor: { colors: ["#CED8F6",
                                                  "#FFFFFF"] }  },
            pan:    { interactive: true,
                      cursor     : 'move', // CSS mouse cursor value used when dragging, e.g. "pointer"
                      frameRate  : 20     }
    };

    if ( $('#chart_zoom').is(':checked') ) {
            options[zoom] = { interactive: true,
                              trigger    : 'dblclick', // or "click" for single click
                              amount     : 1.5 };      // 2 = 200% (zoom in), 0.5 = 50% (zoom out)
    }
    $.ajax({ url     : uri_base+'/test/chart',
             data    : { tank_id:          tank_id,
                         sdate:            $('#sdate').val(),
                         edate:            $('#edate').val(),
                         chart_ph:         $('#chart_ph').is(':checked')         ? 1 : 0,
                         chart_ammonia:    $('#chart_ammonia').is(':checked')    ? 1 : 0,
                         chart_nitrite:    $('#chart_nitrite').is(':checked')    ? 1 : 0,
                         chart_nitrate:    $('#chart_nitrate').is(':checked')    ? 1 : 0,
                         chart_calcium:    $('#chart_calcium').is(':checked')    ? 1 : 0,
                         chart_phosphate:  $('#chart_phosphate').is(':checked')  ? 1 : 0,
                         chart_magnesium:  $('#chart_magnesium').is(':checked')  ? 1 : 0,
                         chart_kh:         $('#chart_kh').is(':checked')         ? 1 : 0,
                         chart_alkalinity: $('#chart_alkalinity').is(':checked') ? 1 : 0,
                         chart_salinity:   $('#chart_salinity').is(':checked')   ? 1 : 0
                       },
             dataType: 'json',
             type    : 'POST',
             success : function(data, status) {
                            if ( data.length < 1 ) {
                                return alert("No test results available for charting (check selected date range).");
                            }

                            var yaxes = [];

                            // Put each dataset's measurement on its own Y-axis.
                            // This permits better scaling when vastly different
                            // test results are being charted (eg. Ca ppm vs. pH)
                            for ( var i = 1; i <= data.length; i++ ) {
                                yaxes.push({position: 'left'});
                            }
                            options.yaxes = yaxes;

                            $.plot($("#testChartDiv"), data, options);
                            var previousPoint = null;
                            $('#testChartDiv').unbind("plothover");
                            $('#testChartDiv').bind("plothover",
                                                    function (event, pos, item) {
                                    if ( item ) {
                                        if (previousPoint != item.dataIndex) {
                                            previousPoint = item.dataIndex;

                                            $("#tooltip").remove();
                                            var x=(new Date(item.datapoint[0])).strftime('%Y-%m-%d');
                                            var y=item.datapoint[1];
                                            chartTooltip(item.pageX,
                                                         item.pageY,
                                                         item.series.label + " on " + x + " : " + y);
                                        }
                                    }
                                    else {
                                        $("#tooltip").remove();
                                        previousPoint = null;
                                    }
                            });
                        },
             error   :  function( req, textStatus, errorThrown ) {
                            var e = "generateChart() AJAX call failed";
                            if ( textStatus  ) { e += ": " + textStatus; }
                            if ( errorThrown ) { e += " (" + errorThrown + ")"; }
                            e += " req==>"+req+"<==";
                            alert(e);
                            return false;
                        }
    });
}

function toggleChartOpts(selState) {
    var chartOpts = $(':checkbox[name^=chart_]');

    $.each(chartOpts, function(i, obj) { $(obj).attr('checked', selState); });
}

function toggleTankEdit(selState) {
    if ( selState ) {
        $('#tankNotes').enable();
        $('#editTankBar').show();
        $('#editTankButton').hide();
    }
    else {
        $('#tankNotes').disable();
        $('#editTankBar').hide();
        $('#editTankButton').show();
    }
}

var currentTestRowId; // id of currently-selected water test row when subgrid expands

function initTestResultGrid (args) {

    var tank_id      = args.tank_id;
    var is_saltwater = args.is_saltwater;
    var user_id      = args.user_id;

    if ( ! tank_id ) return alert("Cannot initialise test result grid - no tank selected!");
    if ( ! user_id ) return alert("Cannot initialise test result grid - no user!");

    var colNames = [ ' ', 'ID', 'Tank ID', 'Date', 'User ID', 'User',
                     'Ph','NH<sub>4</sub>', 'NO<sub>2</sub>', 'NO<sub>3</sub>' ];

    var colModel = [ { name :        'rowActions',
                       width:        30,
                       fixed:        true,
                       sortable:     false,
                       resize:       false,
                       formatter:    'actions',
                       formatoptions:{ keys:           true,
                                       editbutton:     true,
                                       delbutton:      false,
                                       editformbutton: false,
                                       editOptions:    { mtype:    'POST',
                                                         editData: { 'tank_id': tank_id,
                                                                     'user_id': user_id,
                                                                     'test_id': function () {
                                                                        var row_id = $('#testResultTable').jqGrid('getGridParam', 'selrow');

                                                                        return $('#testResultTable').jqGrid('getRowData', row_id).test_id;
                                                                                            }
                                                                   },
                                                       },
                                     }
                      },
                      { name:        'test_id',
                        index:       'test_id',
                        key:         true,
                        width:       40,
                        align:       'right',
                        hidden:      false,
                        editable:    false
                      },
                      { name:        'tank_id',
                        index:       'tank_id',
                        width:       40,
                        align:       'right',
                        hidden:      true,
                      },
                      { name:        'test_date',
                        index:       'test_date',
                        width:       100,
                        align:       'center',
                        datefmt:     'Y-m-d',
                        editable:    true,
                        editoptions: { size:     10,
                                       dataInit: function (element) {
                                            $(element).val((new Date()).strftime('%Y-%m-%d'));
                                            $(element).datepicker({ dateFormat:      'yy-mm-dd',
                                                                    showOn:          'button',
                                                                    showAnim:        'fold',
                                                                    buttonImage:     'images/calendar.gif',
                                                                    buttonImageOnly: true
                                            });
                                                 }
                                     },
                        editrules:   { date:     true,
                                       required: true }
                      },
                      { name:        'user_id',
                        index:       'user_id',
                        width:       40,
                        align:       'right',
                        hidden:      true,
                      },
                      { name:        'user_name',
                        index:       'user_name',
                        width:       40,
                        align:       'left',
                        hidden:      true
                      },
                      { name:        'result_ph',
                        index:       'result_ph',
                        width:       50,
                        align:       'right',
                        editable:    true,
                        editoptions: { size:     6 },
                        editrules:   { number:   true,
                                       required: true },
                        formatter:   'number'
                      },
                      { name:        'result_ammonia',
                        index:       'result_ammonia',
                        width:       50,
                        align:       'right',
                        editable:    true,
                        editoptions: { size:     6 },
                        editrules:   { number:   true,
                                       required: true },
                        formatter:   'integer'
                      },
                      { name:        'result_nitrite',
                        index:       'result_nitrite',
                        width:       50,
                        align:       'right',
                        editable:    true,
                        editoptions: { size:     6 },
                        editrules:   { number:   true,
                                       required: true },
                        formatter:   'integer'
                      },
                      { name:        'result_nitrate',
                        index:       'result_nitrate',
                        width:       50,
                        align:       'right',
                        editable:    true,
                        editoptions: { size:     6 },
                        editrules:   { number:   true,
                                       required: true },
                        formatter:   'integer'
                      },
                   ];

    if ( is_saltwater ) {
        // append the saltwater specific cols:
        colNames.push('S.G.', 'Ca', 'PO<sub>3</sub>', 'Mg', '<sup>0</sup>Kh', 'Alk');
        colModel.push({ name:        'result_salinity',
                        index:       'result_salinity',
                        width:       50,
                        align:       'right',
                        editable:    true,
                        editoptions: { size:     6 },
                        editrules:   { number:   true,
                                       required: true },
                        formatter:   'number',
                        formatoptions: { decimalPlaces: 3 }
                      },
                      { name:        'result_calcium',
                        index:       'result_calcium',
                        width:       50,
                        align:       'right',
                        editable:    true,
                        editoptions: { size:     6 },
                        editrules:   { number:   true,
                                       required: true },
                        formatter:   'integer'
                      },
                      { name:        'result_phosphate',
                        index:       'result_phosphate',
                        width:       50,
                        align:       'right',
                        editable:    true,
                        editoptions: { size:     6 },
                        editrules:   { number:   true,
                                       required: true },
                        formatter:   'number'
                      },
                      { name:        'result_magnesium',
                        index:       'result_magnesium',
                        width:       50,
                        align:       'right',
                        editable:    true,
                        editoptions: { size:     6 },
                        editrules:   { number:   true,
                                       required: true },
                        formatter:   'integer'
                      },
                      { name:        'result_kh',
                        index:       'result_kh',
                        width:       50,
                        align:       'right',
                        editable:    true,
                        editoptions: { size:     6 },
                        editrules:   { number:   true,
                                       required: true },
                        formatter:   'integer'
                      },
                      { name:        'result_alkalinity',
                        index:       'result_alkalinity',
                        width:       50,
                        align:       'right',
                        editable:    true,
                        editoptions: { size:     6 },
                        editrules:   { number:   true,
                                       required: true },
                        formatter:   'number'
                      });
    }

    colNames.push('Water Change');
    colModel.push({ name:        'water_change',
                    index:       'water_change',
                    width:       90,
                    align:       'right',
                    editable:    true,
                    editoptions: { size:     6 },
                    editrules:   { number:   true,
                                   required: true },
                    formatter:   'integer'
                  });

    $("#testResultTable").jqGrid({
        url:           uri_base+'/test/results',
        editurl:       uri_base+'/test',
        postData:      { 'tank_id': tank_id },
        datatype:      'json',
        mtype:         'GET',
        height:        250,
        autowidth:     true,
        width:         800,
        shrinkToFit:   true,
        gridview:      true,
        altRows:       true,
        scrollrows:    true,
        autoencode:    true,
        viewrecords:   true,
        emptyrecords:  'No test records found.',
        rowNum:        10,
        rowList:       [10,20,30],
        pager:         '#testResultPager',
        sortname:      'test_date',
        sortorder:     'desc',
        multiselect:   false,
        recreateForm:  true,
        jsonReader:    { root:        'tests',
                         page:        'curr_page',
                         total:       'total_pages',
                         records:     'total_records',
                         repeatitems: false
                       },
        colNames:      colNames,
        colModel:      colModel,
        subGrid:       true,
        subGridRowExpanded:
                       function (subgrid_id, row_id) {
            // when expanding a new subgrid, collapse the previously-selected one:
            if ( currentTestRowId != row_id ) {
                if ( currentTestRowId ) {
            		$("#testResultTable").jqGrid('collapseSubGridRow', currentTestRowId);
                }
                currentTestRowId = row_id;
            }

            var subgrid_table_id = subgrid_id+"_t";
            var subgrid_pager_id = subgrid_id+"_p";
            var test_id = $("#testResultTable").jqGrid('getRowData', row_id).test_id;

            $("#"+subgrid_id).html("<table id='"+subgrid_table_id+"' class='scroll'></table><div id='"+subgrid_pager_id+"'></div>");
            $("#"+subgrid_table_id).jqGrid({
                    url:           uri_base+'/diary/test_note',
                    editurl:       uri_base+'/diary/test_note',
                    postData:      { 'test_id':  test_id },
                    mtype:         'GET',
                    datatype:      "json",
                    autowidth:     true,
                    height:        75,
                    gridview:      true,
                    altRows:       true,
                    autoencode:    true,
                    viewrecords:   true,
                    multiselect:   false,
                    pager:         '#'+subgrid_pager_id,
                    // we're only using the pager to get the 'Add' button functionality
                    // to allow a note to be added to a water test... we don't actually
                    // want any navigation, so the next few settings disable the pagination
                    // & navigation stuff that usually appears in the middle of the pager widget:
                    rowList:       [],     // disable page size dropdown
                    pgbuttons:     false,  // disable page control like next, back button
                    pgtext:        null,   // disable pager text like 'Page 0 of 10'
                    recordtext:    null,   // 
                    viewrecords:   false,  // disable current view record text like 'View 1-10 of 10
                    emptyrecords:  'No no note recorded for selected test..',
                    // if there is a note for the test, then disable the Add button from the
                    // pager:
                    gridComplete: function () {
                                      var numRec = $("#"+subgrid_table_id).jqGrid('getGridParam', 'records');
                                      if ( numRec > 0 ) {
                                          // at least 1 row, so hide the 'Add' button from the navgrid
                                          $('#add_'+subgrid_table_id).hide();
                                      }
                                              },
                    loadError: function (x,s,e) {
                                      if ( s ) { msg += " Status: "+s; }
                                      if ( e ) { msg += " Error: "+e.toString(); }
                                          else { msg += " (no error object)"; }
                                      alert(msg);
                                                },
                    jsonReader:    { root: 'page' },
                    colNames:      [' ','Id','User','Test Date','Last Updated','Diary Note'],
                    colModel:      [
                      { name :        'rowActions',
                        width:        30,
                        fixed:        true,
                        sortable:     false,
                        resize:       false,
                        formatter:    'actions',
                        formatoptions:{ keys:           true,
                                        editbutton:     true,
                                        delbutton:      false,
                                        editformbutton: false,
                                        editOptions:    { url:              uri_base+'/diary',
                                                          mtype:            'POST',
                                                          modal:             true,
                                                          closeAfterAdd:     true,
                                                          clearAfterAdd:     true,
                                                          editCaption:       'Edit notes for test #'+test_id+':',
                                                          closeAfterEdit:    true,
                                                          reloadAfterSubmit: true,
                                                          closeOnEscape:     true
                                                        }
                                      }
                      },
                      { name:         'diary_id',
                        index:        'diary_id',
                        hidden:       true,
                        key:          true,
                        editable:     false
                      },
                      { name:         'user_id',
                        index:        'user_id',
                        hidden:       true,
                        editable:     false
                      },
                      { name:         'diary_date',
                        index:        'diary_date',
                        hidden:       true,
                        editable:     false
                      },
                      { name:         'updated_on',
                        index:        'updated_on',
                        width:        90,
                        editable:     false
                      },
                      { name:        'diary_note',
                        index:       'diary_note',
                        width:       550,
                        align:       'left',
                        editable:    true,
                        edittype:    'textarea',
                        editoptions: { rows: 5,
                                       cols: 70 }
                      },
                    ],
            });

            $("#"+subgrid_table_id).jqGrid(
                    'navGrid',
                    '#'+subgrid_pager_id,
                    { add:           true,
                      addtitle:      'Add a note about the selected test results.',
                      reloadAfterSubmit: true,
                      del:           false,
                      edit:          false,
                      refresh:       false,
                      refreshstate:  'current',
                      search:        false,
                    },
                    {},
                    { // add settings
                      addCaption:    'Add a note to selected test:',
                      url:           uri_base+'/diary',
                      mtype:         'POST',
                      modal:         true,
                      editData:      { 'tank_id': tank_id,
                                       'user_id': user_id,
                                       'test_id': test_id
                                     },
                      closeAfterAdd: true,
                      closeOnEscape: true,
                      width:         550,
                      height:        150,
                      left:          140,
                      top:           240
                    },
                    {}, // delete settings
                    {}, // search settings
                    {}  // view settings
            );
        }
    });

    $("#testResultTable").jqGrid('navGrid',
                                 '#testResultPager',
                                 { add:           true,
                                   addtitle:      'Record new water test results.',
                                   reloadAfterSubmit: true,
                                   del:           false,
                                   edit:          false,
                                   refreshstate:  'current',
                                   search:        false,
                                 },
                                 {}, // edit settings
                                 {   // add settings
                                   addCaption:    'Add new water test record:',
                                   url:           uri_base+'/test',
                                   mtype:         'POST',
                                   modal:         true,
                                   editData:      { 'tank_id': tank_id,
                                                    'user_id': user_id },
                                   closeAfterAdd: true
                                 },
                                 {}, // delete settings
                                 {}, // search settings
                                 {}  // view settings
                                );
/*
 * These can be handy hooks:
              beforeSubmit: function(postdata, formid) {
                                alert("beforeSubmit() hooked via 'ADD'");
                                return [true,'beforeSubmit() called on formid='+formid+'... proceeding'];
                            },

              afterSubmit:  function(resp,data) {
                                //alert("afterSubmit() hooked via 'ADD'");
                                $(".ui-icon-closethick").trigger('click');
                                //return [ resp.success, resp.message, null ];
                            }
*/
}

function initDiaryGrid (args) {

    var tank_id      = args.tank_id;
    var is_saltwater = args.is_saltwater;
    var user_id      = args.user_id;

    if ( ! tank_id ) return alert("Cannot initialise diary grid - no tank selected!");
    if ( ! user_id ) return alert("Cannot initialise diary grid - no user!");

    var colNames = [ ' ', 'Tank_id', 'User ID', 'User Name', 'Diary ID',
                     'Date',  'Updated', 'Diary Note', 'Test ID' ];

    var colModel = [ { name :        'rowActions',
                       width:        30,
                       fixed:        true,
                       sortable:     false,
                       resize:       false,
                       formatter:    'actions',
                       formatoptions:{ keys:           true,
                                       editbutton:     true,
                                       delbutton:      false,
                                       editformbutton: false,
                                       editOptions:    {
                                           url:               uri_base+'/diary',
                                           mtype:             'POST',
                                           reloadAfterSubmit: true,
                                                       },
                                     }
                      },
                      { name:        'tank_id',
                        index:       'tank_id',
                        width:       40,
                        align:       'right',
                        hidden:      true,
                        editable:    true
                      },
                      { name:        'user_id',
                        index:       'user_id',
                        width:       40,
                        align:       'right',
                        hidden:      true,
                        editable:    false
                      },
                      { name:        'user_name',
                        index:       'user_name',
                        width:       40,
                        align:       'left',
                        hidden:      true,
                        editable:    false
                      },
                      { name:        'diary_id',
                        index:       'diary_id',
                        key:         true,
                        width:       40,
                        align:       'right',
                        hidden:      true,
                        editable:    false
                      },
                      { name:        'diary_date',
                        index:       'diary_date',
                        width:       60,
                        align:       'center',
                        datefmt:     'Y-m-d',
                        editable:    false
                      },
                      { name:        'updated_on',
                        index:       'updated_on',
                        width:       60,
                        align:       'center',
                        datefmt:     'Y-m-d',
                        hidden:      true,
                        editable:    false
                      },
                      { name:        'diary_note',
                        index:       'diary_note',
                        width:       550,
                        align:       'left',
                        editable:    true,
                        edittype:    'textarea',
                        editoptions: { rows: 10,
                                       cols: 70 }
                      },
                      { name:        'test_id',
                        index:       'test_id',
                        width:       40,
                        align:       'right',
                        editable:    false,
                      }
                   ];

    $("#diaryTable").jqGrid({
        url:           uri_base+'/diary',
        editurl:       uri_base+'/diary',
        postData:      { 'tank_id':  tank_id },
        datatype:      'json',
        mtype:         'GET',
        height:        250,
        autowidth:     true,
        width:         800,
        shrinkToFit:   true,
        gridview:      true,
        altRows:       true,
        scrollrows:    true,
        autoencode:    true,
        viewrecords:   true,
        emptyrecords:  'No diary entries found.',
        rowNum:        10,
        rowList:       [10,20,30],
        pager:         '#diaryPager',
        sortname:      'diary_date',
        sortorder:     'desc',
        multiselect:   false,
        recreateForm:  true,
        jsonReader:    { root:        'diary',
                         page:        'curr_page',
                         total:       'total_pages',
                         records:     'total_records',
                         repeatitems: false
                       },
        colNames:      colNames,
        colModel:      colModel
    });
    $("#diaryTable").jqGrid('navGrid',
                            '#diaryPager',
                            { add:           true,
                              addtitle:      'Enter new diary note.',
                              reloadAfterSubmit: true,
                              del:           false,
                              edit:          false,
                              refreshstate:  'current',
                              search:        false,
                            },
                            {}, // edit settings
                            {   // add settings
                              addCaption:    'Add new diary note:',
                              url:           uri_base+'/diary',
                              mtype:         'POST',
                              modal:         true,
                              editData:      { 'tank_id': tank_id,
                                               'user_id': user_id },
                              closeAfterAdd: true,
                              closeOnEscape: true,
                              width:         550,
                              height:        250
                            },
                            {}, // delete settings
                            {}, // search settings
                            {}  // view settings
                           );
}

function initInventoryGrid (args) {

    var tank_id  = args.tank_id;
    var user_id  = args.user_id;
    var gridName = args.gridName;
    var class_id = args.class_id;

    //alert("initGrid '"+gridName+"' class_id="+class_id);

    if ( ! tank_id ) return alert("Cannot initialise "+gridName+" grid - no tank selected!");
    if ( ! user_id ) return alert("Cannot initialise "+gridName+" grid - no user!");

    var colNames = [ ' ', 'Item ID', 'Tank ID', 'User ID', 'Description',
                     'Type', 'Purchase Date',  'Price', 'Quantity' ];

    var colModel = [ { name :        'rowActions',
                       width:        30,
                       fixed:        true,
                       sortable:     false,
                       resize:       false,
                       formatter:    'actions',
                       formatoptions:{ keys:           true,
                                       editbutton:     true,
                                       delbutton:      false,
                                       editformbutton: false,
                                       editOptions:    {
                                           url:               uri_base+'/inventory',
                                           mtype:             'POST',
                                           reloadAfterSubmit: true,
                                                       },
                                     }
                      },
                      { name:        'item_id',
                        index:       'item_id',
                        key:         true,
                        width:       40,
                        align:       'right',
                        hidden:      true,
                        editable:    false
                      },
                      { name:        'tank_id',
                        index:       'tank_id',
                        width:       40,
                        align:       'right',
                        hidden:      true,
                        editable:    false
                      },
                      { name:        'user_id',
                        index:       'user_id',
                        width:       40,
                        align:       'right',
                        hidden:      true,
                        editable:    false
                      },
                      { name:        'description',
                        index:       'description',
                        width:       410,
                        align:       'left',
                        hidden:      false,
                        editable:    true,
                        editoptions: { size: 80 },
                        editrules:   { required: true }
                      },
                      { name:        'type',
                        index:       'type',
                        width:       150,
                        align:       'left',
                        editable:    true,
                        edittype:    'select',
                        editoptions: { dataUrl: uri_base+'/inventory/types?class_id='+class_id },
                        editrules:   { edithidden: true }
                      },
                      { name:        'purchase_date',
                        index:       'purchase_date',
                        width:       120,
                        align:       'center',
                        datefmt:     'Y-m-d',
                        editable:    true,
                        editoptions: { size:     12,
                                       dataInit: function (element) {
                                            $(element).datepicker({dateFormat:      'yy-mm-dd',
                                                                   showOn:          'button',
                                                                   showAnim:        'fold',
                                                                   buttonImage:     'images/calendar.gif',
                                                                   buttonImageOnly: true });
                                            $(element).val((new Date()).strftime('%Y-%m-%d'));
                                                                    }
                                     },
                        editrules:   { date:     true,
                                       required: true }
                      },
                      { name:        'purchase_price',
                        index:       'purchase_price',
                        width:       100,
                        align:       'right',
                        editable:    true,
                        formatter:   'currency',
                        editrules:   { number:   true,
                                       minValue: 0 }
                      },
                      { name:        'quantity',
                        index:       'quantity',
                        width:       70,
                        align:       'right',
                        editable:    true,
                        editrules:   { number: true,
                                       minValue: 0 }
                      }
                   ];

    $('#'+gridName+'Table').jqGrid({
        url:           uri_base+'/inventory',
        editurl:       uri_base+'/inventory',
        postData:      { 'tank_id':  tank_id,
                         'class_id': class_id },
        datatype:      'json',
        mtype:         'GET',
        height:        250,
        autowidth:     true,
        width:         800,
        shrinkToFit:   true,
        gridview:      true,
        altRows:       true,
        scrollrows:    true,
        autoencode:    true,
        viewrecords:   true,
        emptyrecords:  "No "+gridName+" inventory items found.",
        rowNum:        10,
        rowList:       [10,20,30],
        pager:         '#'+gridName+'Pager',
        sortname:      'purchase_date',
        sortorder:     'desc',
        multiselect:   false,
        recreateForm:  true,
        jsonReader:    { root:        'inventory',
                         page:        'curr_page',
                         total:       'total_pages',
                         records:     'total_records',
                         repeatitems: false
                       },
        colNames:      colNames,
        colModel:      colModel
    });
    $('#'+gridName+'Table').jqGrid('navGrid',
                                   '#'+gridName+'Pager',
                            { add:           true,
                              addtitle:      "Enter new "+gridName+" inventory item.",
                              reloadAfterSubmit: true,
                              del:           false,
                              edit:          false,
                              refreshstate:  'current',
                              search:        false
                            },
                            {}, // edit settings
                            {   // add settings
                              addCaption:    "Add new "+gridName+" inventory item:",
                              modal:         true,
                              editData:      { 'tank_id': tank_id,
                                               'user_id': user_id },
                              closeAfterAdd: true,
                              closeOnEscape: true,
                              width:         620,
                              height:        205
                            },
                            {}, // delete settings
                            {}, // search settings
                            {}  // view settings
                           );

}

