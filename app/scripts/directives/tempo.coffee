'use strict'

angular.module('9095App')
  .directive('tempo', ($window, $document, sequencer) ->
    templateUrl: 'views/directives/tempo.html'
    restrict: 'E'
    replace: true
    link: (scope, element, attrs) ->
      scope.$on 'tempo-select', (e, tempo) ->
        sequencer.setTempo(tempo)
        scope.settings.tempo = sequencer.getTempo()

      scope.settings =
        tempo: sequencer.getTempo()
      
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

      calculateTempo = (angle) ->
        value = angle*(180/Math.PI)
        if value < 0
          value = Math.abs(Math.floor(value))
        else if value >= 0
          value = Math.floor(180+Math.abs((value-180)))
        value = Math.floor(value)
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
          #_x = event.originalEvent.targetTouches[0].clientX
          #_y = event.originalEvent.targetTouches[0].clientY

        if _x != 0 and _y != 0
          #_y -= $(document).scrollTop()
          #console.log "#{_x} - #{_y}"
          angle = Math.atan2(_x-position.centerX, _y-position.centerY)
          pos =
            "top": position.radius+Math.cos(angle)*position.radius
            "left": position.radius+Math.sin(angle)*position.radius
          
          #if pos.top < 50
          scope.settings.tempo = calculateTempo(angle)
          scope.$apply () ->
            sequencer.setTempo(scope.settings.tempo)
          element.find('.dot').css(pos)
      
      last_time = (new Date()).getTime()
      last_bpms = []

      average_bpm = () ->
        Math.floor(last_bpms.reduce((a,b) -> a+b)/last_bpms.length)

      #bpm_hits = 0
      scope.countBPM = () ->
        #if ++bpm_hits < 3
        #  return
        this_time = (new Date()).getTime()
        last_bpms.push(Math.floor(60000/(this_time-last_time)))

        last_bpms = last_bpms.slice(1) if last_bpms.length > 5
        #console.log last_bpms
        last_time = this_time

        scope.settings.tempo = average_bpm()
        sequencer.setTempo(scope.settings.tempo)
        
        #sequencer.restart()
        #if bpm_hits%4 == 0
        #sequencer.stopPlay()
        #sequencer.startPlay(true)
  )
