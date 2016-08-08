'use strict'

angular.module('9095App')
  .directive('notifications', ($timeout, $location, notifications) ->
    templateUrl: 'views/directives/notifications.html'
    restrict: 'E'
    replace: true
    link: (scope, element, attrs) ->
      visible = $location.url().slice(1).length > 0

      displayNotification = (event, notification) ->
        scope.notification.message = notification.message
        element.show()
        scope.notification.visible = true

      hideNotification = () ->
        scope.notification.visible = false
        $timeout(() ->
          element.hide()
        , 300)

      scope.notification =
        visible: visible
        message: 'Loading...'

      if !visible
        hideNotification()
      
      scope.$on('show-notification', displayNotification)
      scope.$on('hide-notification', hideNotification)
  )
