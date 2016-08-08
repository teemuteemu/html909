'use strict'

angular.module('9095App')
  .directive('controlPanel', (sequencer, utils, toArrayFilter) ->
    templateUrl: 'views/directives/control-panel.html'
    restrict: 'E'
    replace: true
    scope: true
    link: (scope, element, attrs) ->
      if utils.isSmallScreen()
        scope.label = scope.control.id.split('_').map((n) -> n[0] ).join('')
      else
        scope.label = scope.control.id.split('_').join(' ')

      scope.label = scope.label.toUpperCase()
      scope.knobs = toArrayFilter(scope.control.data.knobs)

      scope.isSelectedInstrument = () ->
        return sequencer.getSelectedInstrument() == scope.control.id
    
      scope.selectInstrument = (instru_id) ->
        sequencer.setSelectedInstrument(scope.control.id)
        scope.$root.$broadcast('pattern-select')
  )
