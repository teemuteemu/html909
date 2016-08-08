'use strict'

angular.module('9095App')
  .directive('trackSelect', (sequencer, keyboard) ->
    templateUrl: 'views/directives/track-select.html'
    restrict: 'E'
    replace: true
    link: (scope, element, attrs) ->
      scope.tracks = [0..3]
      scope.patterns = [0..3]

      scope.selected =
        orig_track: 0
        track: 0
        pattern: 0

      scope.setTrack = (_track) ->
        scope.selected.track = _track

      scope.setPattern = (_pattern) ->
        scope.selected.orig_track = scope.selected.track
        scope.selected.pattern = _pattern
        sequencer.setSelectedPattern(scope.selected.orig_track, scope.selected.pattern)
        scope.$root.$broadcast('pattern-select')

      keyboard.assign(49, () ->
        scope.setTrack(0)
        scope.$apply()
      )

      keyboard.assign(50, () ->
        scope.setTrack(1)
        scope.$apply()
      )

      keyboard.assign(51, () ->
        scope.setTrack(2)
        scope.$apply()
      )

      keyboard.assign(52, () ->
        scope.setTrack(3)
        scope.$apply()
      )

      keyboard.assign(113, () ->
        scope.setPattern(0)
        scope.$apply()
      )

      keyboard.assign(119, () ->
        scope.setPattern(1)
        scope.$apply()
      )

      keyboard.assign(101, () ->
        scope.setPattern(2)
        scope.$apply()
      )

      keyboard.assign(114, () ->
        scope.setPattern(3)
        scope.$apply()
      )
  )
