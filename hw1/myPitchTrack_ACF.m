%% Blockwise Pitch Tracking based on ACF
% [f0, timeInSec] = myPitchTrack_ACF(x, windowSize, hopSize, fs)
% Input:
%   x = N*1 float vector, input signal
%   windowSize = int, window size of the blockwise process
%   hopSize = int, hop size of the blockwise process
%   fs = float, sample rate in Hz
% Output:
%   f0 = numBlocks*1 float vector, detected pitch (Hz) per block
%   timeInSec  = numBlocks*1 float vector, time stamp (sec) of each block
% CW @ GTCMT 2015
%
% @author Chris Laguna, Ying Zhan

function [f0, timeInSec] = myPitchTrack_ACF(x, windowSize, hopSize, fs)
 
  min_f0 = 100;
  max_f0 = 1000;
  
  min_period_hertz = 1 / min_f0;
  min_period_samples = floor(min_period_hertz * fs);
  
  max_period_hertz = 1 / max_f0;
  max_period_samples = floor(max_period_hertz * fs);

  % Block signal
  x_blocked = BlockSignal(x, windowSize, hopSize);
  num_blocks = size(x_blocked, 1);
  
  f0 = zeros(num_blocks, 1);
  timeInSec = zeros(num_blocks, 1);
  
  for block_idx = 1:num_blocks
    block = x_blocked(block_idx, :).';
    [similarity, shifts] = My_Correlation(block, block);
    
    % The autocorrelation is symmetric, so we can remove the *left side* of
    % the function. We can also remove zero shift, since we are looking for
    % frequencies > 0.
    good_indices = find(shifts > max_period_samples & ...
                        shifts < min_period_samples);
    similarity = similarity(good_indices);
    shifts = shifts(good_indices);
    
    % Normalize the autocorrelation to remove the triangular shape.
    length_similarity = size(similarity, 1);
    for idx = 1:length_similarity
      normalization = windowSize / (windowSize - (0.99 * shifts(idx)));
      similarity(idx) = similarity(idx) * normalization;
    end
    
    % Find maximum index of similarity.
    [~, max_idx] = My_Max(similarity);
    shift_samples = shifts(max_idx);
    
    % Convert number of samples to duration.
    fundamental_period_seconds = shift_samples / fs;
    
    % Convert duration to frequency.
    fundamental_period_hertz = 1 / fundamental_period_seconds;
    
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