window.sort_items = (item) ->
  $show = $(item).closest 'tbody'
  $showItems = $show.children 'tr'

  $showItems.sort (a,b) ->
    a = parseTime $(a).find('.sortable-at').text()
    b = parseTime $(b).find('.sortable-at').text()
    if(a < b)
      return 1
    if(a > b)
      return -1
    return 0

  $showItems.detach().appendTo $show

parseTime = (timeString) ->
  if (timeString == '')
    return null

  time = timeString.match(/(\d+)(:(\d\d))?\s*(p?)/i)
  if (time == null)
    return null

  hours = parseInt(time[1],10)
  if (hours == 12 && !time[4])
    hours = 0
  else
    hours += if (hours < 12 && time[4]) then 12 else 0
  d = new Date()
  d.setHours(hours)
  d.setMinutes(parseInt(time[3],10) || 0)
  d.setSeconds(0, 0)
  d

$(document).on 'ready page:load', ->
  if location.pathname is '/'
    location.hash = '#now'
    $('[autofocus]').focus()

  showNowButton = ->
    $('h4.small-caps-title').animate {width: '85%'}, {duration: 'fast', queue: off}
    $('#now-button').fadeIn 'fast'

  enableScroll = ->
    now = $('#now')
    if now.offset()
      $(window).scroll ->
        diff = Math.abs $(window).scrollTop() - now.offset().top
        if diff > 100
          showNowButton()
          $(window).off 'scroll'
  enableScroll()

  $('#now-button').on 'click touchend', ->
    event.preventDefault()
    $('html, body').animate {scrollTop: $(this.hash).offset().top}, 'fast', ->
      $('h4.small-caps-title').animate {width: '100%'}, {duration: 'fast', queue: off}
      $('#now-button').hide()
      enableScroll()

  $('#submit-to-previous-show').on 'click touchend', ->
    previous = $('#submit-to-previous-show').attr 'data-previous-show'
    $('#override_episode').val 'true'
    $('form#new_song').attr 'action', "/episodes/#{previous}/songs"

  $('#trainee-attendance-hdr').on 'click touchend', ->
    $('#trainee-attendance').slideToggle 'fast'

  $('.best_in_place').bind "best_in_place:success", ->
    window.sort_items(this)


##################
# Autocompletion #
##################
fillFields = (event, ui) ->
  $("#song_name").val ui.item.name
  $("#song_album").val ui.item.album
  $("#song_label").val ui.item.label
  $("#song_year").val ui.item.year
  $("#song_local").prop "checked", ui.item.local
  return false

$(document).on 'ready page:load', ->
  $('#song_name').autocomplete({
    minLength: 4
    source: (request, response) ->
      artistName = $("#song_artist").val()
      if $("#song_artist").val() != ''
        $.getJSON '/songs/find.json', {artist: artistName, name: request.term}, response
    focus: fillFields
    select: fillFields
  }).autocomplete("instance")._renderItem = (ul, item) ->
    $("<li>")
      .append("<strong>#{item.name}</strong> &ndash; <cite>#{item.album}</cite>
               <br/>
               #{item.label} (#{item.year})")
      .appendTo(ul)

