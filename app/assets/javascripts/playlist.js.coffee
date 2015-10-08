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

#$sortItems = (tbody) ->
  #items = tbody.find '#tr'
  #items.sort (a,b) ->
    #a = a.find('.sortable-at').text
    #b = b.find('.sortable-at').text
    #if(a > b)
      #return 1
    #if(a < b)
      #return -1
    #return 0
  #tbody.append items

  $('.best_in_place').bind "ajax:success", ->
    $show = $(this).closest 'tbody'
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
