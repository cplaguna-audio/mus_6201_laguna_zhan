% features: NxM float matrix, N -> time, M -> features
function [features] = ExtractGoodFeatures(audio, block_size, hop_size, fs)
  NUM_SPECTRAL_FEATURES = 5;
  NUM_MFCCS = 20;
  
  num_features = 37; % NUM_SPECTRAL_FEATURES + NUM_MFCCS;
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
    
    features(block_idx, 31:36) = ...
        [cur_centroid; cur_crest; cur_spread; cur_left_slope; ...
         cur_right_slope];
    
    cur_block = blocked_audio(:, block_idx);

%     % MFCCs
    mfcc_start = NUM_SPECTRAL_FEATURES + 1;
    mfcc_stop = mfcc_start + NUM_MFCCS - 1;
    features(block_idx, 11:30) = MFCC(cur_block, NUM_MFCCS, fs).';
    
    % Cepstrum
    cepstrum = Cepstrum(cur_block);
    features(block_idx, 1:10) = cepstrum(1:10).';
  end
  
  % Filterbanks!
  % features(:, 31:35) = ExtractFFTBank(audio, block_size, hop_size, 16);

  flux = SpectralFlux(blocked_mag);
  features(:, 37) = flux;
end