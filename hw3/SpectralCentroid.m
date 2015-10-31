function y = SpectralCentroid(x_blocked)
  
  num_blocks = size(x_blocked, 2);
  x_mag = abs(fft(x_blocked));
  
  y = zeros(num_blocks, 1);
  
  for block_idx = 1:num_blocks
    cur_centroid = 0;
    normalization = 0;
    num_bins = size(x_mag, 1);
    for bin_idx = 1:num_bins / 2;
      cur_centroid = cur_centroid + (bin_idx * x_mag(bin_idx, block_idx));
      normalization = normalization + x_mag(bin_idx, block_idx);
    end

    if(normalization == 0)
      cur_centroid = 0;
    else
      cur_centroid = cur_centroid / normalization;
    end
    
    y(block_idx) = cur_centroid;
  end
end

