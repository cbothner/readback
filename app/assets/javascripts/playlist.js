$(document).on("ready page:load", function() {
  //$(document.body).scrollTop($("#next_up").offset().top);
  if (location.pathname === "/") {
    location.hash = "#now";
    $("[autofocus]").focus();
  }
});
