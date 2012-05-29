$(document).ready ->

  layout_response = ->
    main_width = (($(window).width() - 1036)/2) + 800
    ($ '#main_column').css 'width', (main_width)
    ($ '.listing .main').css 'width', (main_width - 152)

  # layout_response()
  # ($ window).resize ->
  #   layout_response()
