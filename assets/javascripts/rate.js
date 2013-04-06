//$(function() {
   /* call of function from star-rating plugin */
//  $(".star").rating();
//});

function showFormForRate(id) {
  var rate = $('#rate_' + id);
  if(rate.length) {
    rate.hide();
    rate.before($('#new_rate').detach());
  }
  showAndScrollTo('new_rate', 'rate_comment');
}

function beforeSubmitRate(id) {
  $('#rate_' + id).remove();
  $('#new_rate').hide();
}

function cancelRate(id) {
  $('#rate_' + id).show();
  $('#new_rate').hide();
}
