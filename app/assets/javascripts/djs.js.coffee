$(document).ready ->
  $(document).on("click tap", ".interest-link", ->
    interests = $("#dj_interests").val()
    interests += ", " if interests != ''
    $("#dj_interests").val(interests + $(this).attr('data-interest'))
  )

  $(document).on("click tap", ".approval_button", ->
    fieldname = $(this).attr('data-field')
    field = $("#trainee_"+fieldname)
    field.focus()
    field.val($(this).attr('data-date')+' ')

  )

  $(document).on("change", "#dj_um_affiliation", ->
    if $(this).val() == "community"
      $(".hidden").removeClass("hidden")
  )

jQuery ->
  $("#trainee_phone").mask("(999) 999-9999")
