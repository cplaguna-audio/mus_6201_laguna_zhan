function y = MaximumEnvelope(x_blocked)
  num_blocks = size(x_blocked, 2);

  y = zeros(num_blocks, 1);
  for block_idx = 1:num_blocks
    cur_block = x_blocked(:, block_idx);
    cur_maximum_envelope = max(abs(cur_block));
    
    y(block_idx) = cur_maximum_envelope;
  end
end