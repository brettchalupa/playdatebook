local synth = playdate.sound.synth.new(playdate.sound.kWaveSine)

function playSFX(note)
  synth:playMIDINote(note, 1, 0.15)
end
