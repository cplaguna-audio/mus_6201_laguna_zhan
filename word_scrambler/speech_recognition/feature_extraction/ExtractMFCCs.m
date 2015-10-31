% features: NxM float matrix, N -> time, M -> features
function [features] = ExtractMFCCs(audio, block_size, hop_size, fs, num_coeffs)
  blocked_audio = BlockSignal(audio, block_size, hop_size);
  num_blocks = size(blocked_audio, 1);
  
  features = zeros(num_blocks, num_coeffs);
  for block_idx = 1:num_blocks
    cur_block = blocked_audio(block_idx, :).';
    features(block_idx, :) = MFCC(cur_block, num_coeffs, fs).';
  end
end
