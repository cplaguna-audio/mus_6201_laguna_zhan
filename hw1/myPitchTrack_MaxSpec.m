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

% Please write your code here