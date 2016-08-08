'use strict'

angular.module('9095App')
  .service 'sequencer', ($rootScope, $timeout, setup) ->
    
    timer = null
    tempo = setup.getTempo()

    @getTempo = () -> tempo

    @setTempo = (t) ->
      tempo = t
      setup.setTempo(tempo)

    selected =
      track: 0
      pattern: 0
      playing_track: 0
      playing_pattern: 0
      instrument: Object.keys(setup.getSounds())[0]

    tick_index = 0

    nextNoteTime = 0.0
    scheduleAheadTime = 0.1
    look_ahead = 25.0

    notesInQueue = []

    tick = (time) ->
      $rootScope.$broadcast('tick_'+tick_index, {})
      instrument_index = 1

      sounds = setup.getSounds()
      for _sound, _instrument of sounds
        track = _instrument.tracks[selected.playing_track][selected.playing_pattern]
        if track[tick_index] > 0 and _sound != 'accent'
          velocity = track[tick_index] + sounds['accent'].tracks[selected.playing_track][selected.playing_pattern][tick_index]
          setup.playSound(_sound, velocity, time)

      secondsPerBeat = 60.0 / tempo
      nextNoteTime += 0.25 * secondsPerBeat

      if ++tick_index > 15
        tick_index = 0
        selected.playing_track = selected.track
        selected.playing_pattern = selected.pattern

    scheduler = () ->
      while (nextNoteTime < setup.getAudioContext().currentTime + scheduleAheadTime )
        tick(nextNoteTime)
      timer = $timeout(scheduler, look_ahead)

    @getSelectedPattern = () ->
      setup.getSounds()[selected.instrument].tracks[selected.track][selected.pattern]

    @setSelectedPattern = (track, pattern) ->
      #console.log "selected: #{selected.track} #{selected.pattern}"
      
      selected.track = parseInt(track)
      selected.pattern = parseInt(pattern)

      sounds = setup.getSounds()

      for _sound, _instrument of sounds
        if not _instrument.tracks[selected.track]?
          _instrument.tracks[selected.track] =
            [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]

        else if not _instrument.tracks[selected.track][selected.pattern]
          _instrument.tracks[selected.track][selected.pattern] =
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

    @getSelectedInstrument = () ->
      return selected.instrument

    @setSelectedInstrument = (index) ->
      selected.instrument = index

    @setStep = (step, velocity) ->
      #console.log step + ' - '+velocity
      setup.setStepValue(selected.instrument, selected.track, selected.pattern, step, velocity)

    @restart = () ->
      if timer?
        $timeout.cancel(timer)
        tick_index = 0
        nextNoteTime = setup.getAudioContext().currentTime
        scheduler()

    @stopPlay = () ->
      $timeout.cancel(timer)
      timer = null

    @startPlay = (from_start) ->
      tick_index = 0 if from_start
      nextNoteTime = setup.getAudioContext().currentTime
      scheduler()
      
    return this
