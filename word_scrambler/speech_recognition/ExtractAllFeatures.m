function [features] = ExtractAllFeatures(audio, block_size, hop_size, fs)
  [spect_start spect_stop] = GetFeatureIndices('spectral');
  [mfcc_start mfcc_stop] = GetFeatureIndices('mfcc');

  DONT_USE_DELTAS = false;
  
  NUM_MFCC_FEATURES = mfcc_stop - mfcc_start + 1;
  NUM_MFCCS = NUM_MFCC_FEATURES / 2;

  blocked_audio = BlockSignal(audio, block_size, hop_size);
  blocked_audio = blocked_audio.';
  num_blocks = size(blocked_audio, 2);
  
  blocked_freq = fft(blocked_audio);
  blocked_mag = abs(blocked_freq);
  
  prev_centroid = 0;
  prev_crest = 0;
  prev_spread = 0;
  prev_flatness = 0;
  prev_entropy = 0;
  prev_mfccs = zeros(NUM_MFCCS, 1);
  
  features = zeros(num_blocks, mfcc_stop);
  for block_idx = 1:num_blocks
    cur_mag = blocked_mag(:, block_idx);
    
    % Spectral Features.
    cur_centroid = SpectralCentroid(cur_mag);
    delta_centroid = cur_centroid - prev_centroid;
    
    cur_crest = SpectralCrest(cur_mag);
    delta_crest = cur_crest - prev_crest;
    
    cur_spread = SpectralSpread(cur_mag, cur_centroid);
    delta_spread = cur_spread - prev_spread;
    
    cur_flatness = SpectralFlatness(cur_mag);
    delta_flatness = cur_flatness - prev_flatness;
    
    cur_entropy = SpectralEntropy(cur_mag);
    delta_entropy = cur_entropy - prev_entropy;
    
    features(block_idx, spect_start:spect_stop - 2) = ...
        [cur_centroid; cur_crest; cur_spread; cur_flatness; cur_entropy;
         delta_centroid; delta_crest; delta_spread; delta_flatness; delta_entropy];
    
    cur_block = blocked_audio(:, block_idx);

    % MFCCs
    cur_mfccs = MFCC(cur_block, NUM_MFCCS, fs);
    delta_mfccs = cur_mfccs - prev_mfccs;
    
    inst_mfcc_start = mfcc_start;
    inst_mfcc_stop = mfcc_start + NUM_MFCCS - 1;
    features(block_idx, inst_mfcc_start:inst_mfcc_stop) = cur_mfccs.';
    
    delt_mfcc_start = inst_mfcc_stop + 1;
    delt_mfcc_stop = delt_mfcc_start + NUM_MFCCS - 1;
    features(block_idx, delt_mfcc_start:delt_mfcc_stop) = delta_mfccs.';
    
    prev_centroid = cur_centroid;  
    prev_crest = cur_crest;    
    prev_spread = cur_spread;
    prev_flatness = cur_flatness;    
    prev_entropy = cur_entropy;
    prev_mfccs = cur_mfccs;
  end
  
  flux = SpectralFlux(blocked_mag);
  features(:, spect_stop - 1) = flux;

  weighted_phase = WeightedPhaseDeviation(blocked_audio, hop_size);
  weighted_phase = [0; weighted_phase];
  features(:, spect_stop) = weighted_phase;
  
  if(DONT_USE_DELTAS)
    features(:, delt_mfcc_start:delt_mfcc_stop) = 0;
    features(:, 6:10) = 0;
  end
  
  best_features = [10 13 15 5 14 11 29 32 26 2 31 33 12 30 27 28 21 37 4 18 7];
  % features = features(:, best_features);
end