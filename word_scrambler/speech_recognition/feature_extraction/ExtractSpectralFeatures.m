% features: NxM float matrix, N -> time, M -> features
function [features] = ExtractSpectralFeatures(audio, block_size, hop_size)
  NUM_FEATURES = 6;
  blocked_audio = BlockSignal(audio, block_size, hop_size);
  blocked_audio = blocked_audio.';
  num_blocks = size(blocked_audio, 2);
  
  blocked_freq = fft(blocked_audio);
  blocked_mag = abs(blocked_freq);
  
  features = zeros(num_blocks, NUM_FEATURES);
  for block_idx = 1:num_blocks
    cur_mag = blocked_mag(:, block_idx);
    
    cur_centroid = SpectralCentroid(cur_mag);
    cur_crest = SpectralCrest(cur_mag);
    cur_spread = SpectralSpread(cur_mag, cur_centroid);
    cur_left_slope = SpectralLeftSlope(cur_mag, cur_centroid);
    cur_right_slope = SpectralRightSlope(cur_mag, cur_centroid);
    cur_flatness = SpectralFlatness(cur_mag);
    
    features(block_idx, 1:6) = [cur_centroid; cur_crest; cur_spread; cur_left_slope; cur_right_slope; cur_flatness];
  end
  
  flux = SpectralFlux(blocked_mag);
  features(:, 7) = flux;
end