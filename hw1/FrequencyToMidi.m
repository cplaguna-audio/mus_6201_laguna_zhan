function midi = FrequencyToMidi(freq)
  midi = 69 + 12 * log2(freq / 440);
  midi(isinf(midi)) = 0;
end

