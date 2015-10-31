% BlockSignal(x, windowSize, hopSize)
%
% Blocks the signal into a matrix.
% x (n x 1): 
function x_blocked = BlockSignal(x, window_size, hop_size)

  x_length = size(x, 1);
  num_blocks = ceil((x_length - window_size) / hop_size) + 1;
  padded_length = ((num_blocks - 1) * hop_size) + window_size;
    
  % Zero pad so we have equal-lenghts for each block.
  padded_x = zeros(padded_length, 1);
  padded_x(1:x_length) = x;
  
  x_blocked = zeros(num_blocks, window_size);
  
  start_idx = 1;
  stop_idx = start_idx + window_size - 1;
  for block_idx = 1:num_blocks
    x_blocked(block_idx, :) = padded_x(start_idx:stop_idx, 1);
    
    start_idx = start_idx + hop_size;
    stop_idx = start_idx + window_size - 1;
  end

end

