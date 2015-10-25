function y = SpectralCrest(x_mag)
  num_bins = size(x_mag, 1);
  normalization = sum(x_mag(1:num_bins / 2));
  if(normalization == 0)
    y = 0;
    return;
  end
  y = max(x_mag(1:num_bins / 2)) / normalization;
end