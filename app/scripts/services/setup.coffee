'use strict'

angular.module('9095App')
  .service 'setup', ($http, $q, $timeout, $location, $rootScope, presetStorage, notifications) ->
    window.AudioContext = window.AudioContext || window.webkitAudioContext
    audio_context = new AudioContext()
    ready_to_play = $q.defer()

    open_hhs = []
    presets_changed = false
    
    presets = presetStorage.getEmpty()

    master_gain = audio_context.createGain()
    master_gain.gain.value = presets.master_volume

    master_gain.connect(audio_context.destination)

    @getMasterVolume = () ->
      presets.master_volume

    @setMasterVolume = (_volume) ->
      presets.master_volume = _volume
      master_gain.gain.value = presets.master_volume
      presets_changed = true
    
    @getSoundId = (id) ->
      presets.sounds.filter((s) -> return s.id == id)[0] or null

    @getKnobValue = (cid, kid) ->
      presets.sounds[cid].knobs[kid]

    @loadPresets = (id) ->
      presetStorage.load(id).then((presets) =>
        @setPresets(presets)
        $rootScope.$apply () =>
          $rootScope.$broadcast 'pattern-select', presets
          $rootScope.$broadcast 'tempo-select', presets.tempo
          @setMasterVolume(presets.master_volume)
          notifications.hide()

      ).catch((err) ->
        $rootScope.$apply () ->
          notifications.hide()
          $location.url('/')
      )

    @savePresets = ->
      oldID = $location.url().slice(1)

      notification =
        message: 'Saving...'
      notifications.display(notification)
          
      return new Promise (resolve, reject) ->
        presetStorage.save(presets, oldID).then((id) ->
          newUrl = "/#{id}"
          $rootScope.$apply () ->
            $location.url(newUrl)
            notifications.hide()
            resolve(true)
        ).catch((err) ->
          notification =
            message: err
          notifications.display(notification)
          reject(false)
        )
        presets_changed = false

    @clearPresets = ->
      @setPresets(presetStorage.getEmpty())

    @setPresets = (newPresets) ->
      # reset the settings, but keep the audio buffers
      Object.keys(presets.sounds).forEach (sound) ->
        newPresets.sounds[sound].buffer = presets.sounds[sound].buffer

      presets = newPresets
      presets_changed = false

    @getSounds = () ->
      return presets.sounds
    
    @getTempo = ->
      return presets.tempo

    @setTempo = (newTempo) ->
      presets.tempo = newTempo
      presets_changed = true

    @getAudioContext = () ->
      return audio_context

    @ready = () -> ready_to_play.promise

    @loadSounds = () ->
      sounds_ready = 0

      Object.keys(presets.sounds).forEach (sound) ->
        if presets.sounds[sound]? and presets.sounds[sound].buffer?
          # get sound file and put it to .buffer
          $http.get("sounds/#{sound}.wav", {responseType: "arraybuffer"}).success (data) ->
            audio_context.decodeAudioData(data, (buffer) ->
              presets.sounds[sound].buffer = buffer
            )
            if ++sounds_ready == 11
              #console.log "sounds loaded!"
              ready_to_play.resolve()
          , (err) ->
            ready_to_play.reject()
            throw new Error(err)

      return ready_to_play.promise

    @setKnobValue = (instrument, knob, value) ->
      #console.log instrument+': '+knob+': '+value
      presets.sounds[instrument].knobs[knob] = value
      presets_changed = true

    @setStepValue = (instrument, track, pattern, step, value) ->
      presets.sounds[instrument].tracks[track][pattern][step] = value
      presets_changed = true

    @changed = -> presets_changed

    @playSound= (name, velocity, time) ->
      playSound(name, presets.sounds[name], velocity, time)

    playSound = (name, instrument, velocity, time) ->
      source = audio_context.createBufferSource()
      source.buffer = instrument.buffer
      source_gain = audio_context.createGain()

      gain_level = 1
      decay = 1000

      accent_knob_value = presets.sounds['accent'].knobs.value/4
      if velocity > 1
        velocity += accent_knob_value
      
      # closed hhs mutes playing open hhs
      if name == 'cl_hi_hat' and open_hhs.length > 0
        hh = open_hhs.pop()
        if hh?
          hh.stop(time)
          open_hhs = []

      # apply knob values here

      knobParams = Object.keys(instrument.knobs)
      
      if knobParams.indexOf('tune') > -1
        value = instrument.knobs['tune']
        source.playbackRate.value = Math.max(value/2, 0.1)

      if knobParams.indexOf('level') > -1
        value = instrument.knobs['level']
        gain_level = value
        gain_level *= velocity
        source_gain.gain.value = gain_level

      if knobParams.indexOf('decay') > -1
        value = instrument.knobs['decay']
        decay = (value/4)
        source_gain.gain.setValueAtTime(gain_level, audio_context.currentTime)
        source_gain.gain.linearRampToValueAtTime(0, audio_context.currentTime + decay)
          
      # for closing the open hihats
      if name == 'o_hi_hat'
        open_hhs.push(source)

      source.connect(source_gain)
      source_gain.connect(master_gain)

      source.start(time)

    return this
