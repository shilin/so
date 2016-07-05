# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('form.edit_question').show()


binding = ->
  $('.upvote-question-link').on 'ajax:success', (e, data, status, xhr) ->
    e.preventDefault()
    response = $.parseJSON(xhr.responseText)
    id = response.id
    rating = response.rating
    message = response.message
    $('#question_' + id + ' #rating').html(rating)
    $('#flash').html(message)

  .on 'ajax:error', (e, xhr, status, error) ->
    $('#flash').html('')
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('#flash').append(value + "</br>")
      console.log(value)

  $('.downvote-question-link').on 'ajax:success', (e, data, status, xhr) ->
    e.preventDefault()
    response = $.parseJSON(xhr.responseText)
    id = response.id
    rating = response.rating
    message = response.message
    $('#question_' + id + ' #rating').html(rating)
    $('#flash').html(message)

  .on 'ajax:error', (e, xhr, status, error) ->
    $('#flash').html('')
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('#flash').append(value + "</br>")
      console.log(value)

  $('.unvote-question-link').on 'ajax:success', (e, data, status, xhr) ->
    e.preventDefault()
    response = $.parseJSON(xhr.responseText)
    id = response.id
    rating = response.rating
    message = response.message
    $('#question_' + id + ' #rating').html(rating)
    $('#flash').html(message)

  .on 'ajax:error', (e, xhr, status, error) ->
    $('#flash').html('')
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('#flash').append(value + "</br>")
      console.log(value)

$(document).ready(binding) # "вешаем" функцию binding на событие document.ready

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update

