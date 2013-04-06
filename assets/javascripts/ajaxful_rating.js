function insertStarsInput(stars, maxCount) {
  var ratingForm;
  if((ratingForm = $('.ajaxful-rating').parents('form')).length == 0) return;
  if(ratingForm.find('input[name="stars"]').length) {
    ratingForm.find('input[name="stars"]').attr('value', stars);
  } else {
    ratingForm.find('input[type="submit"]').before('<input type="hidden" name="stars" value="' + stars + '">');
  }

  ratingForm.find('.show-value').css('width', stars/maxCount*100 + '%');
}

