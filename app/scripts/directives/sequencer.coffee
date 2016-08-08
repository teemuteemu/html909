'use strict'

angular.module('9095App')
  .directive('sequencer', ($rootScope, sequencer) ->
    templateUrl: 'views/directives/sequencer.html'
    restrict: 'E'
    replace: true
    link: (scope, element, attrs) ->
      scope.steps = sequencer.getSelectedPattern()

      scope.$on('pattern-select', (event, data) ->
        scope.steps = sequencer.getSelectedPattern()
      )
      
      scope.$on('step-click', (event, data) ->
        sequencer.setStep(data.step, data.on)
      )
  )
