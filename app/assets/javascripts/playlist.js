$(document).on("ready page:load", function() {
  //$(document.body).scrollTop($("#next_up").offset().top);
  if (location.pathname === "/") {
    location.hash = "#now";
    $("[autofocus]").focus();
  }
  function showNowButton() {
    $('h4.small-caps-title').animate({ width: '85%' }, { duration: 'fast', queue: false });
    $('#now-button').fadeIn('fast');
  }

  function enableScroll() {
    now = $("#now");
    if (now.offset()) {
      $(window).scroll(function(){
        var diff = Math.abs($(window).scrollTop() - now.offset().top);
        if (diff > 100) {
          showNowButton();
          $(window).off("scroll")
        }
      });
    }
  }
  enableScroll();

  $('#now-button').on("click touchend", function() {
    event.preventDefault();
    $('html,body').animate({scrollTop:$(this.hash).offset().top}, 'fast', function() {
      $('h4.small-caps-title').animate({ width: '100%' }, { duration: 'fast', queue: false });
      $('#now-button').hide();
      enableScroll();
    });
  });

  $("#submit-to-previous-show").on("click touchend", function() {
    var previous = $("#submit-to-previous-show").attr("data-previous-show");
    $("#override_episode").val('true');
    $("form#new_song").attr("action", "/episodes/"+previous+"/songs");
    debugger;
  });

  $("#trainee-attendance-hdr").on("click touchend", function() {
    $("#trainee-attendance").slideToggle("fast");
  });

});
