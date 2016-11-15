ready = ->
  $(".growl-msg").each ->
    type=$(this).data('type') || 'info'
    $.growl $(this).html(),
      type: type
$(document).on 'turbolinks:load', ready
