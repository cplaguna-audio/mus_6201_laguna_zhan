% onset detection with adaptive thresholding
% [onsetTimeInSec] = myOnsetDetection(nvt, fs, windowSize, hopSize)
% input: 
%   x: N by 1 float vector, input signal
%   fs: float, sampling frequency in Hz
%   windowSize: int, number of samples per block
%   hopSize: int, number of samples per hop
% output: 
%   onsetTimeInSec: n by 1 float vector, onset time in second

function [onsetTimeInSec] = myOnsetDetection(nvt, fs, windowSize, hopSize)
  
  ORDER = 19;
  LAMBDA = 0.074;

  % Normalize the novelty function.
  nvt = nvt ./ max(abs(nvt));
  nvt = smooth(nvt, 3, 'moving');
  thres = myMedianThres(nvt, ORDER, LAMBDA);

  [peak_vals, peak_indices] = findpeaks(nvt);
  
  true_peak_indices = [];
  
  num_peaks = size(peak_vals, 1);
  for cur_peak = 1:num_peaks
     cur_peak_val = peak_vals(cur_peak);
     cur_peak_idx = peak_indices(cur_peak);
     cur_thres = thres(cur_peak_idx);
     
     if(cur_peak_val > cur_thres)
         true_peak_indices = [true_peak_indices; cur_peak_idx];
     end
     
  end
  
  
  onsetTimeSamples = ((true_peak_indices - 1) .* hopSize) + (windowSize / 2);
  onsetTimeInSec = onsetTimeSamples / fs;
end