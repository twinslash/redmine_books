function showFormForRate(id) {
  var rate = $('#rate_' + id);
  if(rate.length) {
    rate.hide();
    rate.before($('#new_rate').detach());
  }
  showAndScrollTo('new_rate', 'rate_comment');
}

function cancelRate(id) {
  $('#rate_' + id).show();
  $('#new_rate').hide();
}
