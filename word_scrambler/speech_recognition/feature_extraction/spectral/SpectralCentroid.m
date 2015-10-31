function y = SpectralCentroid(x_mag)

  y = 0;
  normalization = 0;
  num_bins = size(x_mag, 1);
  for bin_idx = 1:num_bins / 2;
    y = y + (bin_idx * x_mag(bin_idx));
    normalization = normalization + x_mag(bin_idx);
  end
  
  if(normalization == 0)
    y = 0;
    return;
  end
  y = y / normalization;
end

