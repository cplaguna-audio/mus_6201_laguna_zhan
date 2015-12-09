% x_mags: N x M matrix, N -> freq, M -> time.
function y = QMaxSpectralFlux(x_mags, quantile)
  [num_bins, num_blocks] = size(x_mags);
  fft_size = num_bins / 2;
  
  K = ceil(fft_size * quantile); 
  
  y = zeros(num_blocks, 1);
  for block_idx = 2:num_blocks
    cur_freq_mag = x_mags(:, block_idx);
    past_freq_mag = x_mags(:, block_idx - 1);

    flux_per_bin = abs(cur_freq_mag(1:fft_size) - past_freq_mag(1:fft_size)).^2;
    flux_per_bin_sorted = sort(flux_per_bin, 'descend');
    k_flux_per_bin = flux_per_bin_sorted(1:K);
    current_spectral_flux = sqrt(sum(k_flux_per_bin)) / K;
    y(block_idx) = current_spectral_flux;
  end
  
end

