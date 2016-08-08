'use strict'

angular.module('9095App')
  .factory 'utils', () ->
    return {
      isSmallScreen: -> (window.innerWidth < 768)
    }
