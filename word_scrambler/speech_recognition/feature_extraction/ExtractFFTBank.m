% |num_bands|-band filter bank extracted by averaging over magnitude 
% spectrum. Bands are spaced equally in frequency. 
% features: NxM float matrix, N -> time, M -> features
function [features] = ExtractFFTBank(audio, block_size, hop_size, num_bands)
  blocked_audio = BlockSignal(audio, block_size, hop_size);
  num_blocks = size(blocked_audio, 1);
  num_bins_per_band = block_size / (2 * num_bands);
  features = zeros(num_blocks,num_bands);
  for block_idx = 1:num_blocks
    block_magnitude = abs(fft(blocked_audio(block_idx, :))).';
    
    bin_start = 1;
    bin_stop = bin_start + num_bins_per_band - 1;
    for band_idx = 1:num_bands
      current_band = mean(block_magnitude(bin_start:bin_stop));
      features(block_idx, band_idx) = current_band;

      bin_start = bin_start + num_bins_per_band;
      bin_stop = bin_start + num_bins_per_band - 1;
    end
  end
  
  features = features(:, 1:5);
end
