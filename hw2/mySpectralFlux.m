%% Novelty function: spectral flux
% [nvt] = myPeakEnv(x, w, windowSize, hopSize)
% input: 
%   x: N by 1 float vector, input signal
%   windowSize: int, number of samples per block
%   hopSize: int, number of samples per hop
% output: 
%   nvt: n by 1 float vector, the resulting novelty function 

function [nvt] = mySpectralFlux(x, windowSize, hopSize)
  x_blocked = blockSignal(x, windowSize, hopSize);
  num_blocks = size(x_blocked, 1);
  fftSize = windowSize / 2;
  nvt = zeros(num_blocks, 1);

  % For block_idx = 1, we use spectral-flux = 0. We don't want to detect
  % an onset during the first block.
  nvt(1) = 0;

  for block_idx = 2:num_blocks
    cur_block = x_blocked(block_idx, :).';
    past_block = x_blocked(block_idx - 1, :).';
    cur_freq_mag = abs(fft(cur_block));
    past_freq_mag = abs(fft(past_block));

    flux_per_bin = abs(cur_freq_mag(1:fftSize) - past_freq_mag(1:fftSize)).^2;
    current_spectral_flux = sqrt(sum(flux_per_bin)) / fftSize;
    nvt(block_idx) = current_spectral_flux;
  end
end