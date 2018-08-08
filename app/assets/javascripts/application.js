// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/widgets/autocomplete
//= require jquery-ui/widgets/datepicker
//= require jquery-ui/widgets/draggable
//= require jquery-ui/widgets/droppable
//= require jquery-ui/widgets/tabs
//= require jquery-ui/widgets/selectable
//= require activestorage
//= require trix
//= require turbolinks
//= require best_in_place
//= require_tree .

$(document).on("ready turbolinks:load", function() {

  jQuery(".best_in_place").best_in_place();

  if ( $('[type="date"]').prop('type') != 'date' ) {
    $("[type='date']").datepicker({
      dateFormat: 'yy-mm-dd'
    });
  }

  $(".chzn-select").chosen({width: '100%'});

});

var TAB_KEY_CODE = 9

document.addEventListener('keydown', function (e) {
  if (e.which === TAB_KEY_CODE) {
    document.body.classList.add('tab-focus')
  }
})

document.addEventListener('click', function (e) {
  document.body.classList.remove('tab-focus')
})
