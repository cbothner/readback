$(document).on("ready page:load", function() {
  //$(document.body).scrollTop($("#next_up").offset().top);
  if (location.pathname === "/") {
    location.hash = "#now";
    $("[autofocus]").focus();
  }
  function showNowButton() {
    $('#now-button').fadeIn('fast');
  }

  function enableScroll() {
    $(window).scroll(function(){
      var diff = Math.abs($(window).scrollTop() - $("#now").offset().top);
      console.log( diff );
      if (diff > 100) {
        showNowButton();
        $(window).off("scroll")
      }
    });
  }
  enableScroll();

  $('#now-button').on("click touchend", function() {
    event.preventDefault();
    $('html,body').animate({scrollTop:$(this.hash).offset().top}, 'fast', function() {
      $('#now-button').hide();
      enableScroll();
    });
  });
});
