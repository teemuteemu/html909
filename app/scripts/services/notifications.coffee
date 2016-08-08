'use strict'

angular.module('9095App')
  .factory 'notifications', ($rootScope) ->

    @display = (notification) ->
      $rootScope.$broadcast('show-notification', notification)

    @hide = () ->
      $rootScope.$broadcast('hide-notification')

    return this
