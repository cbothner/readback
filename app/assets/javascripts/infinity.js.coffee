loadMorePlaylistItems = ->
  d = $("#infinity").data()
  return if !d

  action = d.action
  delete d.action  # Everything else is params

  $.getJSON(action, d).success (data) ->
    items = []
    $.each data.items, ->
      items.push "<tr>#{this.html}</tr>"
    $("table.playlist tr:last").after items

    if items.length == 0
      $("#infinity").remove()
    else
      for key, value of data
        if key.startsWith 'new_'
          toBeSet = key.slice(4)  # Everything after 'new_'
          $("#infinity").data toBeSet, value

    $("#infinity").data 'action', action  # Restore deleted action
    window.loadingArchive = false

$(document).on 'ready turbolinks:load', ->
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
