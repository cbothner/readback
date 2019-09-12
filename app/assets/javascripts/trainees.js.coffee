matches = (el, words) ->
  doesMatch = false
  for word in words
    if el.attr('data-interests').indexOf(word) != -1
      doesMatch = true
  doesMatch

$(document).on "ready turbolinks:load", ->

  $(document).off 'click tap', '.interest-link'
  $(document).on "click tap", ".interest-link", ->
    traineeInterests = $("#trainee_interests")
    interests = traineeInterests.val()
    interests += ", " if interests != ''
    traineeInterests.val(interests + $(this).attr('data-interest'))
    traineeInterests.trigger "input"

  $(document).on "change", "#trainee_um_affiliation", ->
    if $(this).val() == "community" || $(this).val() == "alumnus"
      $(".hidden").removeClass("hidden")

  $(document).on "input", "#trainee_interests", ->
    searchStrings = $(this).val().split(', ')
    trainees = $(".trainee")

    hiddenTrainees = trainees.filter(':hidden')
    traineesToHide = trainees.filter ->
      !matches( $(this), searchStrings )
    traineesToHide.each ->
      $(this).slideUp("fast")

    traineesToShow = trainees.filter(":hidden").filter ->
      matches( $(this), searchStrings )
    traineesToShow.each ->
      $(this).slideDown("fast")

    #numHidden = hiddenTrainees.length + traineesToHide.length - traineesToShow.length
    #hiddenString = "#{numHidden} trainee#{if numHidden == 1 then ' is' else 's are'} filtered out."
    #$('.hidden-trainees').text(hiddenString) unless numHidden == 0

jQuery ->
  $("#trainee_phone").mask("(999) 999-9999")
