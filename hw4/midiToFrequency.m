function freq = midiToFrequency(midi, tuning)
  freq = 2^((midi - 69) / 12) * tuning;
end
