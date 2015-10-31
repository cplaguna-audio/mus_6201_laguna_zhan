function y = SpectralSpread(x_mag, centroid_bin)
  num_bins = size(x_mag, 1);
  y = 0;
  normalization = 0;
  for bin_idx = 1:num_bins / 2
    distance_from_centroid = abs(centroid_bin - bin_idx);
    y = y + (distance_from_centroid * x_mag(bin_idx));
    normalization = normalization + x_mag(bin_idx);
  end
  
  if(normalization == 0)
    y = 0;
    return;
  end
  
  y = y / normalization;
end

