# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    form_id = 'edit_answer_' + answer_id
    $('form#' + form_id).show()

binding = ->
  $('.upvote-answer-link').on 'ajax:success', (e, data, status, xhr) ->
    render_success(e, data, status, xhr)
  .on 'ajax:error', (e, xhr, status, error) ->
    render_error(e, xhr, status, error)

  $('.downvote-answer-link').on 'ajax:success', (e, data, status, xhr) ->
    render_success(e, data, status, xhr)
  .on 'ajax:error', (e, xhr, status, error) ->
    render_error(e, xhr, status, error)

  $('.unvote-answer-link').on 'ajax:success', (e, data, status, xhr) ->
    render_success(e, data, status, xhr)
  .on 'ajax:error', (e, xhr, status, error) ->
    render_error(e, xhr, status, error)

render_success = (e, data, status, xhr) ->
    e.preventDefault()
    response = $.parseJSON(xhr.responseText)
    id = response.id
    rating = response.rating
    message = response.message
    $('#answer_block_' + id + ' .rating').html(rating)
    $('#flash').html(message)

render_error = (e, xhr, status, error) ->
    $('#flash').html('')
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('#flash').append(value + "</br>")
      console.log(value)

$(document).ready(binding) # "вешаем" функцию binding на событие document.ready

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready

$(document).on('page:load', binding)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', binding) # "вешаем" функцию ready на событие page:update
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update

