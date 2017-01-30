# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

checkMedia = ->
  if window.matchMedia('(max-width: 1136px)').matches
    $('.image').on 'click', (e) ->
      $(this).hide()
      $(this).siblings('.text').show()
    $('.text').on 'click', (e) ->
      $(this).hide()
      $(this).siblings('.image').show()
  else
    $('.image').off 'click'
    $('.text').off 'click'
    $('.text').show()
    $('.image').show()


$(document).on("turbolinks:load", checkMedia)
$(document).change(checkMedia)
$(window).resize(checkMedia)
