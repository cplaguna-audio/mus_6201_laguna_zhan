function y = ZeroCrossingRate(x_blocked)
  [window_size, num_blocks] = size(x_blocked);

  y = zeros(num_blocks, 1);
  for block_idx = 1:num_blocks
    number_zero_crossings = 0;
    
    for sample_idx = 2:window_size
      cur_sample = x_blocked(sample_idx, block_idx);
      prev_sample = x_blocked(sample_idx - 1, block_idx);
      if(sign(cur_sample) ~= sign(prev_sample))
        number_zero_crossings = number_zero_crossings + 1;
      end
    end
    
    y(block_idx) = number_zero_crossings;
  end
end