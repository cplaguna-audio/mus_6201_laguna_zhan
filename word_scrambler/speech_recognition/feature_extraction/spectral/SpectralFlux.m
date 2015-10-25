% x_mags: N x M matrix, N -> freq, M -> time.
function y = SpectralFlux(x_mags)
  [num_bins, num_blocks] = size(x_mags);
  fft_size = num_bins / 2;
  
  y = zeros(num_blocks, 1);
  for block_idx = 2:num_blocks
    cur_freq_mag = x_mags(:, block_idx);
    past_freq_mag = x_mags(:, block_idx - 1);

    flux_per_bin = abs(cur_freq_mag(1:fft_size) - past_freq_mag(1:fft_size)).^2;
    current_spectral_flux = sqrt(sum(flux_per_bin)) / fft_size;
    y(block_idx) = current_spectral_flux;
  end
  
end
