$(document).on 'ready turbolinks:load', -> $('#tabs').tabs()

$(document).on 'ready turbolinks:load', ->
  $('#semesters').on 'change', ->
    window.location = @selectedOptions[0].value
