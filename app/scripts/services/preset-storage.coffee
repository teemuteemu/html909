'use strict'

angular.module('9095App')
  .factory 'presetStorage', ($location) ->
      firebaseAppUrl = 'TODO: set this if you want to use firebase for saving/loading'

      presets = {
        tempo: 120
        master_volume: 1.0
        sounds: {
          accent: {
            position: 0
            knobs: {
              value: 2
            }
            tracks: [
              [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
              ]
            ]
          }
          bass_drum:{
            position: 1
            buffer: 'notset'
            knobs: {
              tune: 2
              level: 1
              decay: 2
            }
            tracks: [
              [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
              ]
            ]
          }
          snare_drum: {
            position: 2
            buffer: 'notset'
            knobs: {
              tune: 2
              level: 1
              decay: 2
            }
            tracks: [
              [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
              ]
            ]
          }
          low_tom: {
            position: 3
            buffer: 'notset'
            knobs: {
              tune: 2
              level: 1
              decay: 2
            }
            tracks: [
              [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
              ]
            ]
          }
          mid_tom: {
            position: 4
            buffer: 'notset'
            knobs: {
              tune: 2
              level: 1
              decay: 2
            }
            tracks: [
              [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
              ]
            ]
          }
          hi_tom: {
            position: 5
            buffer: 'notset'
            knobs: {
              tune: 2
              level: 1
              decay: 2
            }
            tracks: [
              [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
              ]
            ]
          }
          rim_shot: {
            position: 6
            buffer: 'notset'
            knobs: {
              level: 1
            }
            tracks: [
              [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
              ]
            ]
          }
          hand_clap: {
            position: 7
            buffer: 'notset'
            knobs: {
              level: 1
            }
            tracks: [
              [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
              ]
            ]
          }
          cl_hi_hat: {
            position: 8
            buffer: 'notset'
            knobs: {
              level: 1
              decay: 2
            }
            tracks: [
              [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
              ]
            ]
          }
          o_hi_hat: {
            position: 9
            buffer: 'notset'
            knobs: {
              level: 1
              decay: 2
            }
            tracks: [
              [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
              ]
            ]
          }
          crash: {
            position: 10
            buffer: 'notset'
            knobs: {
              level: 1
              tune: 2
            }
            tracks: [
              [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
              ]
            ]
          }
          ride: {
            position: 11
            buffer: 'notset'
            knobs: {
              level: 1
              tune: 2
            }
            tracks: [
              [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
              ]
            ]
          }
        }
      }

      getFireBaseRef = (url) ->
        connection = new Firebase(url)
        return connection

      @save = (newPresets, oldID) ->

        trackData = $.extend(true, {}, newPresets)
        Object.keys(trackData.sounds).forEach (sound) ->
          if trackData.sounds[sound].buffer
            trackData.sounds[sound].buffer = 'notset'
          else
            delete trackData.sounds[sound].buffer
        
        return new Promise (resolve, reject) ->
          # overwrite existing preset
          if oldID.length > 0
            presetUrl = "#{firebaseAppUrl}/tracks/#{oldID}"
            fbRef = getFireBaseRef(presetUrl)
            fbRef.update(trackData).then((result) ->
              resolve(oldID)
            ).catch((err) ->
              reject(err)
            )
        
          # save new preset
          else
            fbRef = getFireBaseRef(firebaseAppUrl)
            tracksRef = fbRef.child('tracks')

            tracksRef.push(trackData).then((result) ->
              id = result.key()
              
              if id
                resolve(id)
              else
                reject(id)
            ).catch((err) ->
              reject(err)
            )

      @load = (id) ->
        presetUrl = "#{firebaseAppUrl}/tracks/#{id}"
        fbRef = getFireBaseRef(presetUrl)

        return new Promise (resolve, reject) ->
          fbRef.once 'value', (data) ->
            presets = data.val()
            
            if presets
              resolve(presets)
            else
              reject("ID #{id} not found")

      @getEmpty = ->
        return $.extend(true, {}, presets)

      return this

