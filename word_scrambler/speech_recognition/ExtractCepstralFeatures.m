% features: NxM float matrix, N -> time, M -> features
function [features] = ExtractCepstralFeatures(audio, block_size, hop_size)
  NUM_FEATURES = 15;
  blocked_audio = BlockSignal(audio, block_size, hop_size);
  blocked_audio = blocked_audio.';
  num_blocks = size(blocked_audio, 2);
  
  features = zeros(num_blocks, NUM_FEATURES);
  for block_idx = 1:num_blocks    
    cur_block = blocked_audio(:, block_idx);
    cepstrum = Cepstrum(cur_block);
    features(block_idx, 1:NUM_FEATURES) = cepstrum(1:NUM_FEATURES).';
  end

end