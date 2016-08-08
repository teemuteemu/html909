'use strict'

angular.module('9095App')
  .directive('knob', ($window, $document, setup) ->
    templateUrl: 'views/directives/knob.html'
    restrict: 'E'
    replace: true
    scope: true
    link: (scope, element, attrs) ->
      scope.sound_name = scope.control.id
      scope.value = setup.getKnobValue(scope.sound_name, scope.knob.id)
      scope.label = scope.knob.id.toUpperCase()
      scope.label = ' ' if scope.sound_name == 'accent'
      
      _x = 0
      _y = 0

      position = {
        radius: 0
        centerX: 0
        centerY: 0
      }

      setDimensions = () ->
        the_knob = element.find('.knob')
        position.radius = (the_knob.width()/2)-2
        position.centerX = the_knob.offset().left+position.radius
        position.centerY = the_knob.offset().top+position.radius
      setDimensions()

      angular.element($window).bind 'resize', ->
        setDimensions()
      
      element.find('.dot').css(
        top: 3
        left: 17
      )

      scope.setValue = () ->
        setup.setKnobValue(scope.sound_name, scope.knob.id, scope.value)

      calculateAngle = (value) ->
        angle = (value/4)*(2*Math.PI)
        if angle < Math.PI
          angle = angle*-1
        if angle > Math.PI
          angle = 2*Math.PI - angle
        #console.log value
        #console.log angle
        return angle

      calculateValue = (angle) ->
        value = angle*(180/Math.PI)
        if value < 0
          value = Math.abs(Math.floor(value))
        else if value >= 0
          value = Math.floor(180+Math.abs((value-180)))
        #value = (Math.floor(value/31)-1)/2
        value = (value/360)*4
        #console.log value
        return value

      getRotationAngle = (inputC, knobC) ->
        return Math.atan2(inputC[0]-knobC[0], inputC[1]-knobC[1])
      
      rotateDotCss = (angle, radius) ->
        #console.log angle
        pos =
          "top": position.radius+Math.cos(angle)*position.radius
          "left": position.radius+Math.sin(angle)*position.radius
        element.find('.dot').css(pos)
      
      rotateDotCss(calculateAngle(scope.value), position.radius)

      scope.$on 'pattern-select', (event, data) ->
        scope.value = setup.getKnobValue(scope.sound_name, scope.knob.id)
        rotateDotCss(calculateAngle(scope.value), position.radius)

      document.onmouseup = (event) ->
        document.onmousemove = null
      
      knob = element.find('.knob')
      knob.bind('mousedown', (event) ->
        document.onmousemove = on_move
      )

      knob.bind('touchstart', (event) ->
        event.preventDefault()
        #console.log 'touchstart'

        knob.addClass('knob-zoom')
        setDimensions()

        $document.bind('touchmove', on_move)
        $document.bind('touchend', on_end)
      )

      on_end = (event) ->
        knob.removeClass('knob-zoom')
        setDimensions()
        
        angle = getRotationAngle([_x, _y], [position.centerX, position.centerY])
        rotateDotCss(angle, position.radius)

        $document.unbind('touchmove')
        $document.unbind('touchend')

      on_move = (event) ->
        event.preventDefault()
        #console.log "draggin"
        _x = event.pageX
        _y = event.pageY+position.radius
        
        # this is a touch event
        if event.originalEvent? and event.originalEvent.targetTouches? and event.originalEvent.targetTouches[0]?
          _x = event.originalEvent.targetTouches[0].pageX
          _y = event.originalEvent.targetTouches[0].pageY

        if _x != 0 and _y != 0
          angle = getRotationAngle([_x, _y], [position.centerX, position.centerY])

          rotateDotCss(angle, position.radius)
          scope.value = calculateValue(angle)

          scope.setValue()
          scope.$apply()
  )
