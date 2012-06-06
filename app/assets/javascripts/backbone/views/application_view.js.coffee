$(document).ready ->

  layout_init = ->
    window_height = ($ window).height()
    ($ '#main_column').css 'min-height', window_height
  
  layout_init()

  layout_response = ->
    main_width = (($(window).width() - 1036)/2) + 800
    ($ '#main_column').css 'width', (main_width)
    ($ '.listing .main').css 'width', (main_width - 152)

  # layout_response()
  # ($ window).resize ->
  #   layout_response()
