requirejs(['jquery','colpick'], function($) {
    $('#calc_capacity').click(function() {

        var dimension_units  = $('select[name="dimension_units"]').val();
        var dimension_factor = 1;
        var dimension_metric = true;

        switch (dimension_units) {
            case 'mm':
                 dimension_factor = 0.001; //conv. to metres
                 break;

            case 'cm':
                dimension_factor = 0.01; // conv. to metres
                break;

            case 'inches':
                dimension_factor = 1/12; // conv. to feet
                dimension_metric = false;
                break;
            case 'feet':
                dimension_metric = false;
                break;
            default:
                alert('You must select dimension units before calculating capacity');
                return false;
        }

        // volume here is either cubic metre, or cubic feet:
        var volume = ($('input[name="length"]').val() * dimension_factor) *
                     ($('input[name="width"]').val()  * dimension_factor) *
                     ($('input[name="depth"]').val()  * dimension_factor);

        var capacity_units = $('select[name="capacity_units"]').val();
        var capacity_factor;

        /* volume conversion rates:
            1 cubic meter = 1 000 litre
            1 cubic meter = 219.969 248 3 gallon [UK]
            1 cubic meter = 264.172 052 36 gallon [US, liquid]

            1 cubic foot = 28.316 846 592 litre
            1 cubic foot = 6.228 835 459 gallon [UK]
            1 cubic foot = 7.480 519 480 5 gallon [US, liquid]
        */

        switch (capacity_units) {
            case 'litres':
                capacity_factor = dimension_metric ? 1000 : 28.316846592;
                break;
            case 'gallons':
                capacity_factor = dimension_metric ? 219.9692483 : 6.228835459;
                break;
            case 'us gallons':
                capacity_factor = dimension_metric ? 264.17205236 : 7.4805194805;
                break;
            default:
                alert('You must select capacity units before calculating.');
                return false;
        }
        $('input[name="capacity"]').val((volume * capacity_factor).toFixed(2));
    });

    // set bg colour for all rgb_colour inputs
    $('input[name*="_rgb_colour"]').each(function(idx,obj) {
        $(obj).css('background-color', $(obj).val());
    });

    $('#test_attrs').on('shown.bs.modal', function() {
        // when the modal dialog is showing, turn all rgb_colour inputs
        // into a colour picker (if enabled)

        $('input[name*="_rgb_colour"]').each(function(idx,obj) {
            if ( $(obj).is(':enabled') ) {
                $(obj).colpick({
                    colorScheme:'light',
                    layout: 'hex',
                    color: $(obj).val(),
                    onSubmit:function(hsb,hex,rgb,el) {
                        $(el).css('background-color', '#'+hex)
                             .val(('#'+hex).toUpperCase());
                        $(el).colpickHide();
                    }
                });
            }
        });
    });
});
