$(document).ready ->
  $(document).on("click tap", ".approval_button", ->
    fieldname = $(this).attr('data-field')
    field = $("#trainee_"+fieldname)
    field.focus()
    field.val($(this).attr('data-date')+' ')

  )

