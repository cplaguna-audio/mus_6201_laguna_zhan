%% Blockwise Pitch Tracking based on Maximum Peak of Spectrum
% [f0, timeInSec] = myPitchTrack_MaxSpec(x, windowSize, hopSize, fs)
% Input:
%   x = N*1 float vector, input signal
%   windowSize = int, window size of the blockwise process
%   hopSize = int, hop size of the blockwise process
%   fs = float, sample rate in Hz
% Output:
%   f0 = numBlocks*1 float vector, detected pitch (Hz) per block
%   timeInSec  = numBlocks*1 float vector, time stamp (sec) of each block
% CW @ GTCMT 2015

function [f0, timeInSec] = myPitchTrack_MaxSpec(x, windowSize, hopSize, fs)
  num_bins = windowSize / 2;
  nyquist = fs / 2;
  resolution = nyquist / num_bins;
  
  % Block signal.
  x_blocked = BlockSignal(x, windowSize, hopSize);
  num_blocks = size(x_blocked, 1);
  
  f0 = zeros(num_blocks, 1);
  timeInSec = zeros(num_blocks, 1);
  
  for block_idx = 1:num_blocks
    block = x_blocked(block_idx, :).';

    % FFT of block.
    block_mag_spect = abs(fft(block));
    
    % Find peak
    [~, max_bin] = My_Max(block_mag_spect);

    % Convert peak to frequency.
    fundamental_period_hertz = (max_bin - 1) * resolution;
    
    f0(block_idx) = fundamental_period_hertz;
    timeInSec(block_idx) = (block_idx - 1) * hopSize * (1 / fs);
  end

end

function [max_value, max_idx] = My_Max(x)
  x_length = size(x, 1);
  max_value = -10000;
  max_idx = -1;
  TOLERANCE = 0.1;
  
  for idx = 1:x_length
    current_value = x(idx);
    
    if(current_value - max_value > TOLERANCE)
      max_value = current_value;
      max_idx = idx;
    end
  end
  
  if(max_idx == -1)
    error('Max value not found');
  end
  
end