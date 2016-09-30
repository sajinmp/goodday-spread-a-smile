ready = ->

  $('#tweet-submit').click ->
    msg = $('#tweet-message').val()
    $.post '/pages/tweet', { 
      message: msg 
    }, (data, status) ->
      $('#file_path').val(data['path'])
      $('#path_form').submit()


$(document).ready(ready)
$(document).on('page:load', ready)
