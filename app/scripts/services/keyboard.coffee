'use strict'

angular.module('9095App')
  .factory 'keyboard', () ->

    callbacks = {}

    fire = (charCode) ->
      if callbacks[charCode]?
        callbacks[charCode]()

    @assign = (charCode, callback) ->
      callbacks[charCode] = callback

    $(document).on('keypress', (e) ->
      fire(e.charCode)
    )

    return this
