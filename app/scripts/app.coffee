'use strict'

angular
  .module('9095App', [
    'ngRoute'
    'ngTouch'
  ])
  .config ($routeProvider, $locationProvider) ->

    #$locationProvider.html5Mode(true).hashPrefix('!')

    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/:load_id',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
  .run () ->
    if (window.screen.lockOrientation?)
      window.screen.lockOrientation('landscape')
