% features: NxM float matrix, N -> time, M -> features
function [features] = ExtractGoodFeatures(audio, block_size, hop_size, fs)
  NUM_SPECTRAL_FEATURES = 5;
  NUM_MFCCS = 13;
  
  num_features = NUM_SPECTRAL_FEATURES + NUM_MFCCS;
  blocked_audio = BlockSignal(audio, block_size, hop_size);
  blocked_audio = blocked_audio.';
  num_blocks = size(blocked_audio, 2);
  
  blocked_freq = fft(blocked_audio);
  blocked_mag = abs(blocked_freq);
  
  features = zeros(num_blocks, num_features);
  for block_idx = 1:num_blocks
    % Spectral Features.
%     cur_mag = blocked_mag(:, block_idx);
%     
%     cur_centroid = SpectralCentroid(cur_mag);
%     cur_crest = SpectralCrest(cur_mag);
%     cur_spread = SpectralSpread(cur_mag, cur_centroid);
%     cur_left_slope = SpectralLeftSlope(cur_mag, cur_centroid);
%     cur_right_slope = SpectralRightSlope(cur_mag, cur_centroid);
%     
%     features(block_idx, 1:5) = [cur_centroid; cur_crest; cur_spread; cur_left_slope; cur_right_slope];
    
    cur_block = blocked_audio(block_idx, :).';

    % MFCCs
    mfcc_start = NUM_SPECTRAL_FEATURES + 1;
    mfcc_stop = mfcc_start + NUM_MFCCS - 1;
    features(block_idx, mfcc_start:mfcc_stop) = MFCC(cur_block, NUM_MFCCS, fs).';
  end
  
  % Filterbanks!
  features(:, 1:5) = ExtractFFTBank(audio, block_size, hop_size, 16);

%   flux = SpectralFlux(blocked_mag);
%   features(:, 6) = flux;
end