impamp.addNowPlaying = ($pad) ->
  $item = $('.now-playing-item').first().clone()

  $item.attr("data-pad-page", impamp.pads.getPage $pad)
  $item.attr("data-pad-key",  impamp.pads.getKey  $pad)

  $nowPlaying = $('#now-playing')

  $item.find(".name").text($pad.find(".name").text())

  # Pass on clicks.
  $item.find("a").click ->
    $pad.find("a").click()

  $audioElement = $pad.find("audio")
  audioElement = $audioElement[0]
  $audioElement.on 'timeupdate', (e) ->
    updateProgressBar($item, $pad, audioElement.currentTime)

  $nowPlaying.append $item
  $item.fadeIn(1000)

impamp.removeNowPlaying = ($pad) ->
  page = impamp.pads.getPage $pad
  key  = impamp.pads.getKey  $pad

  key = impamp.pads.escapeKey(key)

  $item = $(".now-playing-item[data-pad-page='#{page}'][data-pad-key='#{key}']")
  removeItem($item)

impamp.addNowCollaborating = ($pad, playId, colour) ->
  $item = $('.now-playing-item').first().clone()
  $item.attr("data-playId", playId)

  $nowPlaying = $('#now-playing')

  $item.find(".name").text($pad.find(".name").text())
  $item.addClass "disabled"

  if colour?
    bottomColour = colour
    topColour    = impamp.increaseBrightness(colour)

    gradient = "linear-gradient(to bottom, #{topColour}, #{bottomColour})"

    $item.find(".progress .bar").css("background-image", gradient)
  else
    $item.find(".progress .bar").addClass "bar-grey"

  $nowPlaying.append $item
  $item.fadeIn(1000)

impamp.updateNowCollaborating = ($pad, playId, time) ->
  audioElement = $pad.find("audio")[0]
  $item = $(".now-playing-item[data-playId='#{playId.replace("\\", "\\\\")}']")

  updateProgressBar($item, $pad, time)

impamp.removeNowCollaborating = (playId) ->
  $item = $(".now-playing-item[data-playId='#{playId.replace("\\", "\\\\")}']")
  removeItem($item)

updateProgressBar = ($item, $pad, time) ->
  audioElement = $pad.find("audio")[0]

  $progress_bar  = $item.find(".progress .bar")
  $progress_text = $item.find(".progress > span")

  $progress_bar.css
    width: impamp.pads.getPercent($pad, audioElement, time) + "%"

  $progress_text.text impamp.pads.getRemaining($pad, audioElement, time)

removeItem = ($item) ->
  $item.find(".progress").hide()

  # fadeOut, then slide off so that if there are multiple playing items,
  # they will slide up nicely.
  $item.animate
    opacity: 0
  , 1000
  $item.animate
    "margin-left": -1000
  , 1000, ->
    $item.remove()

