% The average slope of points to the left of the centroid.
function y = SpectralRightSlope(x_mag, centroid) 
  if(centroid == 0)
    y = 0;
    return;
  end
  
  num_bins = size(x_mag, 1);
  num_right_bins = (num_bins / 2) - ceil(centroid);
  
  centroid_magnitude = x_mag(round(centroid));
  
  y = 0;
  for bin_idx = 1:num_right_bins
    distance_from_centroid = abs(centroid - bin_idx);
    rise = x_mag(bin_idx) - centroid_magnitude;
    y = y + (rise / distance_from_centroid);
  end
  y = y / num_right_bins;
end