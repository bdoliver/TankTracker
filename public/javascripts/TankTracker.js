function setMsg (msg, err) {

	$('#message').empty();
	$('#message').removeClass('message');
	$('#message').removeClass('error');

	if ( err ) {
		$('#message').addClass('error');
	}

	$('#message').append(msg);
}

function setURL (path) {
	
	return $('#uri_base').val() ? $('#uri_base').val() + path : path;
}

function clearTestResults() {
	$('#testMsg').empty();
	$('#testErr').empty();

	// pre-set the test date to today:
        $('#test_date').val((new Date()).strftime('%Y-%m-%d'));
	$('#test_ph').val('');
	$('#test_ammonia').val('');
	$('#test_nitrite').val('');
	$('#test_nitrate').val('');
	$('#test_calcium').val('');
	$('#test_phosphate').val('');
	$('#test_magnesium').val('');
	$('#test_kh').val('');
	$('#test_alkalinity').val('');
	$('#test_salinity').val('');
	$('#water_change').val('');
	$('#test_notes').val('');
}

function saveTestResults(edit) {
	// if 'edit' is any true value, we are re-saving an existing test
	// which has just been edited:
	var results = { tank_id:         $('#tank_id').val(),
			test_date:       $('#test_date').val(),
			test_ph:         $('#test_ph').val(),
			test_ammonia:    $('#test_ammonia').val(),
			test_nitrite:    $('#test_nitrite').val(),
			test_nitrate:    $('#test_nitrate').val(),
			test_calcium:    $('#test_calcium').val(),
			test_phosphate:  $('#test_phosphate').val(),
			test_magnesium:  $('#test_magnesium').val(),
			test_kh:         $('#test_kh').val(),
			test_alkalinity: $('#test_alkalinity').val(),
			test_salinity:   $('#test_salinity').val(),
			water_change:    $('#water_change').val(),
			test_notes:      $('#test_notes').val() };

	if ( ! results.tank_id ) {
		return alert("Cannot save test results: no tank_id!");
	}
	if ( ! results.test_date ) {
		return alert("Please enter a date for these test results!");
	}

	$.ajax({async:    true,
		url:      setURL('/test'),
		data:     results,
		dataType: 'json',
		type:     'POST',
		success:  function(data,status) {
				if ( ! status || ! data ) { return false; }
				if ( data.err ) {
					$('#testErr').append(data.err);
				}
				if ( data.ok ) {
					clearTestResults();
					setMsg("Saved test results ok.");
				}
				// update the list of tests displayed:
				fetchTestHistory(results.tank_id);
			  },
		error:    function ( req, textStatus, errorThrown ) {
				var e = "saveTestResults() AJAX call failed.";
				if ( textStatus  ) { e += " " + textStatus; }
				if ( errorThrown ) { e += " : " + errorThrown; }
				alert(e);
				return false;
			  }
	});
}

function fetchTestHistory(tank_id) {
	$.ajax({async:    true,
		url:      setURL('/test/history'),
		data:     { tank_id: tank_id },
		dataType: 'html',
		type:     'GET',
		success:  function(html,status) {
				if ( ! status || ! html ) { return false; }
					$('#Test_History').empty();
					$('#Test_History').append(html);
			  },
		error:    function ( req, textStatus, errorThrown ) {
				var e = "saveTestResults() AJAX call failed.";
				if ( textStatus  ) { e += " " + textStatus; }
				if ( errorThrown ) { e += " : " + errorThrown; }
				alert(e);
				return false;
			  }
	});
}

function getTest(test_id, edit) {
	if ( ! test_id ) {
		alert("Cannot display test results: missing test_id!");
		return false;
	}

	$.ajax({ url     : setURL('/test'),
		 async   : false,
		 type    : 'GET',
		 dataType: 'json',
		 data    : { test_id: test_id },
		 success : function(data, status) {
				// was hoping to leave popping up the dialog 
				// until we'd done with it, but for some reason
				// it will not work that way...
				$('#waterTest').dialog('open');

				$('#waterTest').dialog('option', "title", "Tank: "+data.tank_name+" - test #"+test_id+" results");
				$('#waterTest').dialog('option',
						       "buttons",
							edit
							? { 'Save':  function() { saveTestResults(edit);
										  $(this).dialog('close'); },
							    'Close': function() { $(this).dialog('close'); }
							}
							: { 'Close': function() { $(this).dialog('close'); } }
						      );

				$('#test_date').val(data.test_date);
				$('#test_ph').val(data.result_ph);
				$('#test_ammonia').val(data.result_ammonia);
				$('#test_nitrite').val(data.result_nitrite);
				$('#test_nitrate').val(data.result_nitrate);
				$('#test_calcium').val(data.result_calcium);
				$('#test_phosphate').val(data.result_phosphate);
				$('#test_magnesium').val(data.result_magnesium);
				$('#test_kh').val(data.result_kh);
				$('#test_alkalinity').val(data.result_alkalinity);
				$('#test_salinity').val(data.result.salinity);
				$('#water_change').val(data.water_change);
				$('#testNotes').val(data.notes);

				$('#test_date').blur();
				//$('#waterTest').dialog('open');

				return true;
			   },
		 error   : function( req, textStatus, errorThrown ) {
				var e = "getTest() AJAX call failed";
				if ( textStatus  ) { e += ": " + textStatus; }
				if ( errorThrown ) { e += " (" + errorThrown + ")"; }
				//e += " req==>"+req+"<==";
				alert(e);
				return false;
			   }
	});
}

var previousPoint = null;

function chartTooltip(x, y, contents) {
        $('<div id="tooltip">' + contents + '</div>').css( {
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
	     ( 	$('#chart_ph').is(':checked')         ||
		$('#chart_ammonia').is(':checked')    ||
		$('#chart_nitrite').is(':checked')    ||
		$('#chart_nitrate').is(':checked')    ||
		$('#chart_calcium').is(':checked')    ||
		$('#chart_phosphate').is(':checked')  ||
		$('#chart_magnesium').is(':checked')  ||
		$('#chart_kh').is(':checked')         ||
		$('#chart_alkalinity').is(':checked') ||
		$('#chart_salinity').is(':checked') ) ) {
		// ok to update chart...
	}
	else {
		// insufficient selections to chart
		return false;
	}

	var options = {
		lines:  { show: true   },
		points: { show: true   },
		xaxis:  { mode: 'time' },
		grid:   { hoverable: true },
		zoom:   { interactive: true,
			  trigger: "dblclick", // or "click" for single click
			  amount: 1.5          // 2 = 200% (zoom in), 0.5 = 50% (zoom out)
			},
		pan:    { interactive: true,
			  cursor: "move",      // CSS mouse cursor value used when dragging, e.g. "pointer"
			  frameRate: 20
			}
	};

	$.ajax({ url:      setURL('/test/chart'),
	         data:     { tank_id:          tank_id,
			     sdate:            $('#sdate').val(),
			     edate:            $('#edate').val(),
			     chart_ph:         $('#chart_ph').is(':checked') ? 1 : 0,
			     chart_ammonia:    $('#chart_ammonia').is(':checked') ? 1 : 0,
			     chart_nitrite:    $('#chart_nitrite').is(':checked') ? 1 : 0,
			     chart_nitrate:    $('#chart_nitrate').is(':checked') ? 1 : 0,
			     chart_calcium:    $('#chart_calcium').is(':checked') ? 1 : 0,
			     chart_phosphate:  $('#chart_phosphate').is(':checked') ? 1 : 0,
			     chart_magnesium:  $('#chart_magnesium').is(':checked') ? 1 : 0,
			     chart_kh:         $('#chart_kh').is(':checked') ? 1 : 0,
			     chart_alkalinity: $('#chart_alkalinity').is(':checked') ? 1 : 0,
			     chart_salinity:   $('#chart_salinity').is(':checked') ? 1 : 0
			   },
                 dataType: 'json',
                 type:     'POST',
		 success:  function(data, status) {
				if ( data.length > 0 ) {
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
								chartTooltip(item.pageX, item.pageY,
									    item.series.label + " on " + x + " : " + y);
							}
						}
						else {
							$("#tooltip").remove();
							previousPoint = null;            
						}
					});
				}
				else {
					alert("No test results available for charting (check selected date range).");
				}
			   },
		 error:    function( req, textStatus, errorThrown ) {
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

function saveTankEdit() {
	$.ajax({async:    true,
		url:      setURL('/tank'),
		data:     { tank_id: $('#tankForm > #tank_id').val(),
			    notes:   $('#tankNotes').val() },
		dataType: 'json',
		type:     'POST',
		success:  function(data,status) {
				if ( ! status || ! data ) { return false; }
				if ( data.err ) {
					setMsg(data.err, 'error');
				}
				if ( data.ok ) {
					setMsg('Updated tank notes ok.');
					$('#tank_updated_on').html("Last Updated: "+data.updated_on);
				}
				toggleTankEdit(false);
			  },
		error:    function ( req, textStatus, errorThrown ) {
				var e = "saveTankEdit() AJAX call failed.";
				if ( textStatus  ) { e += " " + textStatus; }
				if ( errorThrown ) { e += " : " + errorThrown; }
				alert(e);
				toggleTankEdit(false);
				return false;
			  }
	});
}

var currentTest;

function toggleTestNotes(test_id) {
	// hide prev audit when it's not the current one being toggled...
	if ( currentTest && currentTest != test_id ) {
		if ( $('#testNoteDiv_' + currentTest).is(':visible') ) {
			$('#testNoteDiv_' + currentTest).hide();
		}
		currentTest = null;
	}

	currentTest = test_id;

	if ( $('#testNoteDiv_' + currentTest).is(':visible') ) {
		$('#testNoteDiv_' + currentTest).hide();
	}
	else {
		$('#testNoteDiv_' + currentTest).show();
	}
}

function toggleDiaryEdit(selState) {
	if ( selState ) {
		$('#diaryPage').enable();
		$('#editDiaryBar').show();
		$('#editDiaryButton').hide();
	}
	else {
		$('#diaryPage').disable();
		$('#editDiaryBar').hide();
		$('#editDiaryButton').show();
	}
}

function saveDiaryNote (diary_data) {
	$.ajax({ url     : setURL('/diary'),
		 async   : false,
		 type    : 'POST',
		 dataType: 'json',
		 data    : diary_data,
		 success : function(data, status) {
				$('#diaryNote').val('');
				$('#addDiaryPopup').dialog('close');
				fetchDiaryPages(); // update the diary...
				return true;
			   },
		 error   : function( req, textStatus, errorThrown ) {
				var e = "generateChart() AJAX call failed";
				if ( textStatus  ) { e += ": " + textStatus; }
				if ( errorThrown ) { e += " (" + errorThrown + ")"; }
				//e += " req==>"+req+"<==";
				alert(e);
				return false;
			   }
	});
}

function editDiaryNote(id) {
	alert("would edit diary note #"+id);
}

function fetchDiaryPages(curr_pg) {

	if ( ! curr_pg ) {
		$('#diary_curr_pg').val();
	}

	var diaryData = { tank_id   : $('#diary_tank_id').val(),
			  diaryDate : $('#diaryDate').val(),
			  numDiaryPP: $('#numDiaryPP').val(),
			  curr_pg   : curr_pg };

	$.ajax({ url     : setURL('/diary/pages'),
		 async   : false,
		 type    : 'GET',
		 dataType: 'html',
		 data    : diaryData,
		 success : function(data, status) {
				$('#diaryPages').empty();
				$('#diaryPages').append(data);
				return true;
			   },
		 error   : function( req, textStatus, errorThrown ) {
				var e = "fetchDiaryPages() AJAX call failed";
				if ( textStatus  ) { e += ": " + textStatus; }
				if ( errorThrown ) { e += " (" + errorThrown + ")"; }
				alert(e);
				return false;
			   }
	});
}
