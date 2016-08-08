'use strict'

angular.module('9095App')
  .directive('masterVolume', ($window, $document, setup) ->
    templateUrl: 'views/directives/master-volume.html'
    restrict: 'E'
    replace: true
    link: (scope, element, attrs) ->
      scope.volume = setup.getMasterVolume()
      
      position = {}
      setDimensions = () ->
        the_knob = element.find('.knob')
        position.radius = (the_knob.width()/2)-2
        position.centerX = the_knob.offset().left+position.radius
        position.centerY = the_knob.offset().top+position.radius
      setDimensions()

      angular.element($window).bind 'resize', ->
        setDimensions()
      
      element.find('.dot').css(
        top: 10
        left: 13
      )

      calculateVolume = (angle) ->
        value = angle*(180/Math.PI)
        if value < 0
          value = Math.abs(Math.floor(value))
        else if value >= 0
          value = Math.floor(180+Math.abs((value-180)))
        value = (Math.floor(value/30))/10
        return value

      document.onmouseup = (event) ->
        document.onmousemove = null

      knob = element.find('.knob')
      knob.bind('mousedown', (event) ->
        document.onmousemove = on_drag
      )
      knob.bind('touchstart', (event) ->
        event.preventDefault()
        #console.log 'touchstart'

        #knob.addClass('knob-zoom')

        $document.bind('touchmove', on_drag)
        $document.bind('touchend', () ->
          #knob.removeClass('knob-zoom')
          $document.unbind('touchmove')
        )
      )

      on_drag = (event) ->
        event.preventDefault()
        #console.log "draggin"
        _x = event.pageX
        _y = event.pageY-180

        if event.originalEvent? and event.originalEvent.targetTouches? and event.originalEvent.targetTouches[0]?
          _x = event.originalEvent.targetTouches[0].pageX
          _y = event.originalEvent.targetTouches[0].pageY-180

        if _x != 0 and _y != 0
          #_y -= (position.centerY-(position.radius*2))
          #_y -= $(document).scrollTop()
          angle = Math.atan2(_x-position.centerX, _y-position.centerY)
          pos =
            "top": position.radius+Math.cos(angle)*position.radius
            "left": position.radius+Math.sin(angle)*position.radius
          
          scope.volume = calculateVolume(angle)
          scope.$apply () ->
            setup.setMasterVolume(scope.volume)

          element.find('.dot').css(pos)
  )
