% features: NxM float matrix, N -> time, M -> features
function [features] = ExtractMFCCs(audio, block_size, hop_size, fs, num_coeffs)
  blocked_audio = BlockSignal(audio, block_size, hop_size);
  num_blocks = size(blocked_audio, 1);
  
  features = zeros(num_blocks, num_coeffs);
  for block_idx = 1:num_blocks
    next_block = blocked_audio(block_idx, :).';
    features(block_idx, 1:num_coeffs) = MFCC(next_block, num_coeffs, fs).';
  end
  
%   for block_idx = 2:num_blocks - 1
%     next_block = features(block_idx + 1, 1:num_coeffs);
%     prev_block = features(block_idx - 1, 1:num_coeffs);
%     features(block_idx, num_coeffs + 1:num_coeffs * 2) = (next_block - prev_block) / 2;
%   end
  
  
end
