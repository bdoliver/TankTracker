(function ($) {
  'use strict';

  $.fn.fileInput = function () {
    return this.each(function (index, element) {
      var $input = $(element);

      $input
        .wrap('<div class="input-group wlg" />')
        .before('<input type="text" class="form-control" placeholder="' + $input.attr('placeholder') + '" disabled>')
        .wrap('<span class="input-group-btn" />')
        .wrap('<button class="btn btn-primary btn-file" type="button" />')
        .before($input.data('button'))
        .removeClass();

      $('.btn-file').on('change', 'input', function () {
        var group = $(this).closest('.input-group');

        group.find(':text').val($(this).val().replace(/^.*\\/, ''));
      });
    });
  };
}(jQuery));
