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
  window.loadingArchive = false
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

  loadMorePlaylistItems = ->
    from = $("#infinity").data "from"
    til = $("#infinity").data "til"
    return if !from
    $.getJSON("/playlist/archive.json", {from: from, til: til}).success (data) ->
      items = []
      $.each data.items, ->
        items.push "<tr>#{this.html}</tr>"
      $("#infinity").data "from", data.newfrom
      $("#infinity").data "til", data.newtil
      $("table.playlist tr:last").after items
      window.loadingArchive = false

  $(window).scroll ->
    if $(window).scrollTop() == $(document).height() - $(window).height()
      if !window.loadingArchive
        window.loadingArchive = true
        loadMorePlaylistItems()

  $("#infinity").mouseover ->
    if !window.loadingArchive
      window.loadingArchive = true
      loadMorePlaylistItems()

  $('#submit-to-previous-show').on 'click touchend', ->
    previous = $('#submit-to-previous-show').attr 'data-previous-show'
    $('#override_episode').val 'true'
    $('form#new_song').attr 'action', "/episodes/#{previous}/songs"

  $('#trainee-attendance-hdr').on 'click touchend', ->
    $('#trainee-attendance').slideToggle 'fast'

  $('.best_in_place').bind "best_in_place:success", ->
    window.sort_items(this)
