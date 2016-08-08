'use strict'

angular.module('9095App')
  .directive 'toolbar', (setup, sequencer) ->
    restrict: 'E'
    templateUrl: 'views/directives/toolbar.html'
    link: (scope, element, attrs) ->

      scope.save = ->
        setup.savePresets()
      
      scope.presetsChanged = ->
        return setup.changed()
