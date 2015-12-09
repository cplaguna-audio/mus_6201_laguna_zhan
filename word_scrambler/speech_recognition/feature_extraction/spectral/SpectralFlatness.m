function y = SpectralFlatness(x_mag, centroid_bin)
  num_bins = size(x_mag, 1);
  numerator = 0;
  denominator = 0;
  K = floor(num_bins / 2);
  for bin_idx = 1:K
    if(x_mag(bin_idx) == 0)
      cur_log_mag = 0;
    else
      cur_log_mag = log(x_mag(bin_idx));
    end
    numerator = numerator + cur_log_mag;
    denominator = denominator + x_mag(bin_idx);
  end
  
  if(denominator == 0)
    y = 0;
    return;
  end
  
  y = exp(numerator / K) / (denominator / K);
end

