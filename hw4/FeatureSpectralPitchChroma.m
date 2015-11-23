function [vpc] = FeatureSpectralPitchChroma(X, fs)
  TUNING = 440;
  NUM_OCTAVES = 4;
  START_MIDI = 60;
  
  [num_bins, num_blocks] = size(X);
  freq_resolution = fs / num_bins;
  
  vpc = zeros(12, num_blocks);
  for block_idx = 1:num_blocks
      
    num_steps = 12 * NUM_OCTAVES;  
    for semitone_offset = 0:num_steps - 1
      cur_pitch = mod(semitone_offset, 12) + 1;
      cur_midi = START_MIDI + semitone_offset;
      cur_bottom_freq = midiToFrequency(cur_midi - 0.5, TUNING);
      cur_top_freq = midiToFrequency(cur_midi + 0.5, TUNING);

      bottom_idx = floor(cur_bottom_freq / freq_resolution);
      top_idx = ceil(cur_top_freq / freq_resolution);

      % Sum up all of the energy in this semitone.
      semitone_energy = 0;
      for freq_idx = bottom_idx:top_idx
         cur_mag = X(freq_idx, block_idx);
         semitone_energy = semitone_energy + cur_mag;
      end

      vpc(cur_pitch, block_idx) = vpc(cur_pitch, block_idx) + semitone_energy;
    end
  end

  % Normalize.
  vpc = vpc ./ repmat(sum(vpc), 12, 1);
end
