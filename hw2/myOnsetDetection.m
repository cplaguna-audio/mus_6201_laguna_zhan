%% onset detection with adaptive thresholding
% [onsetTimeInSec] = myOnsetDetection(nvt, fs, windowSize, hopSize)
% input: 
%   x: N by 1 float vector, input signal
%   fs: float, sampling frequency in Hz
%   windowSize: int, number of samples per block
%   hopSize: int, number of samples per hop
% output: 
%   onsetTimeInSec: n by 1 float vector, onset time in second

function [onsetTimeInSec] = myOnsetDetection(nvt, fs, windowSize, hopSize)
  ORDER = 15;
  LAMBDA = 0;
  
  thres = myMedianThres(nvt, ORDER, LAMBDA);
  
  % Subtract the threshold function from the original novelty 
  % function. Only look at peaks > 0 (this is when the original novelty
  % function is greater than the threshold.)
  nvtDiff = nvt - thres;
  [~, peakIndices] = findpeaks(nvtDiff, 'MinPeakHeight', 0);
  
  onsetTimeSamples = ((peakIndices - 1) .* hopSize) + (windowSize / 2);
  onsetTimeInSec = onsetTimeSamples / fs;
end