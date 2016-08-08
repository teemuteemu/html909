'use strict'

angular.module('9095App')
  .directive('startStop', ($window, sequencer, keyboard) ->
    templateUrl: 'views/directives/start-stop.html'
    restrict: 'E'
    replace: true
    link: (scope, element, attrs) ->

      scope.playing = false
      
      scope.start = () ->
        sequencer.startPlay(true)
        scope.playing = true

      scope.restart = () ->
        sequencer.restart()

      scope.stop = () ->
        sequencer.stopPlay()
        scope.playing = false

      scope.toggle = () ->
        return scope.stop() if scope.playing
        return scope.start() if not scope.playing

      # bind spacebar to togglePlay
      keyboard.assign(32, () ->
        if scope.playing
          scope.stop()
        else
          scope.start()
        scope.$apply()
      )
  )
