'use strict'

angular.module('9095App')
  .directive('step', (sequencer) ->
    templateUrl: 'views/directives/step.html'
    replace: true
    scope:
      velocity: '='
    restrict: 'E'
    link: (scope, element, attrs) ->
      index = attrs.sid
      scope.step_index = parseInt(index)+1
      scope.flash = false

      scope.toggleOn = () ->
        scope.velocity = 0 if ++scope.velocity > 2
        sequencer.setStep(index, scope.velocity)

      scope.$on('tick_'+index, (event, data) ->
        scope.flash = true
      )
      
      if parseInt(index) != 0
        scope.$on("tick_0", (event, data) ->
          scope.flash = false
        )
      else
        scope.$on("tick_15", (event, data) ->
          scope.flash = false
        )
  )
