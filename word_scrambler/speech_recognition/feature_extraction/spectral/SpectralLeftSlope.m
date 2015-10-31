% The average slope of points to the left of the centroid.
function y = SpectralLeftSlope(x_mag, centroid)
  if(centroid == 0)
    y = 0;
    return;
  end
  
  num_left_bins = floor(centroid);
  
  centroid_magnitude = x_mag(round(centroid));
  
  y = 0;
  for bin_idx = 1:num_left_bins
    distance_from_centroid = abs(centroid - bin_idx);
    rise = centroid_magnitude - x_mag(bin_idx);
    y = y + (rise / distance_from_centroid);
  end
  y = y / num_left_bins;
end

