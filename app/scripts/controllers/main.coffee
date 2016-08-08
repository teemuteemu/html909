'use strict'

angular.module('9095App')
  .controller 'MainCtrl', ($scope, setup, $routeParams, toArrayFilter) ->
    if $routeParams.load_id?
      setup.loadPresets($routeParams.load_id)
    
    setup.loadSounds().then () ->
      $scope.controls = toArrayFilter(setup.getSounds())
    
    isSupportedBrowser = () ->
      navigator.userAgent.match(/webkit/i) != null

    #if not isSupportedBrowser()
    #  alert('Currently only webkit browsers are supported, sorry!')
    
angular.module('9095App')
  .filter 'toArray', () ->
    return (inputObject) ->
      if inputObject?
        array = Object.keys(inputObject)
          .map((key) ->
            data = inputObject[key]
            {
              id: key
              data: data
            }
          ).sort (a, b) ->
            return a.data.position - b.data.position
        return array
