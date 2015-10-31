function y = SpectralCrest(x_blocked)
  x_mag = abs(fft(x_blocked));
  [num_bins, num_blocks] = size(x_mag);

  y = zeros(num_blocks, 1);
  for block_idx = 1:num_blocks
    cur_crest = 0;
    
    normalization = sum(x_mag(1:num_bins / 2, block_idx));
    if(normalization ~= 0)
      cur_crest = max(x_mag(1:num_bins / 2, block_idx)) / normalization;
    end
    y(block_idx) = cur_crest;
  end
end