%% Novelty function: peak envelope
% [nvt] = myPeakEnv(x, w, windowSize, hopSize)
% input: 
%   x: N by 1 float vector, input signal
%   windowSize: int, number of samples per block
%   hopSize: int, number of samples per hop
% output: 
%   nvt: n by 1 float vector, the resulting novelty function 

function [nvt] = myPeakEnv(x, windowSize, hopSize)

  x_blocked = blockSignal(x, windowSize, hopSize);
  num_blocks = size(x_blocked, 1);
  nvt = zeros(num_blocks, 1);
  for block_idx = 1:num_blocks
    cur_block = x_blocked(block_idx, :).';
    nvt(block_idx) = max(abs(cur_block));
  end
end