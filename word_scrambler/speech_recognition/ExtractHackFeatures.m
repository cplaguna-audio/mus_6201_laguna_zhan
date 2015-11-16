% features: NxM float matrix, N -> time, M -> features
function [features] = ExtractHackFeatures(audio, block_size, hop_size, fs)
  NUM_MFCCS = 20;
  num_features = 1; % NUM_SPECTRAL_FEATURES + NUM_MFCCS;
  blocked_audio = BlockSignal(audio, block_size, hop_size);
  blocked_audio = blocked_audio.';
  num_blocks = size(blocked_audio, 2);
  
  blocked_freq = fft(blocked_audio);
  blocked_mag = abs(blocked_freq);
  
  features = zeros(num_blocks, num_features);
  for block_idx = 1:num_blocks
    % Spectral Features.
    cur_mag = blocked_mag(:, block_idx);
    
    cur_centroid = SpectralCentroid(cur_mag);
    cur_crest = SpectralCrest(cur_mag);
    cur_spread = SpectralSpread(cur_mag, cur_centroid);
    cur_left_slope = SpectralLeftSlope(cur_mag, cur_centroid);
    cur_right_slope = SpectralRightSlope(cur_mag, cur_centroid);
    cur_flatness = SpectralFlatness(cur_mag);
    
%     features(block_idx, 31:35) = ...
%         [cur_centroid; cur_crest; cur_spread; cur_left_slope; ...
%          cur_right_slope];
    
    cur_block = blocked_audio(:, block_idx);

%     % MFCCs
    mfccs = MFCC(cur_block, NUM_MFCCS, fs).';
    
    features(block_idx, 1) = mfccs(3);
    features(block_idx, 2) = mfccs(9);
    features(block_idx, 3) = mfccs(20);
%     
%     % Cepstrum
    cepstrum = Cepstrum(cur_block);
    features(block_idx, 4) = cepstrum(1);
    features(block_idx, 5) = cepstrum(4);
    features(block_idx, 6) = cepstrum(5);
    features(block_idx, 7) = cepstrum(6);
    features(block_idx, 8) = cepstrum(8);
    features(block_idx, 9) = cepstrum(10);
    features(block_idx, 10) = cur_spread;
  end
  
  % Filterbanks!
  % features(:, 31:35) = ExtractFFTBank(audio, block_size, hop_size, 16);

  flux = SpectralFlux(blocked_mag);
  features(:, 11) = flux;
end
