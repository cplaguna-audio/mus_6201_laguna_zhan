% compute binary SDM matrix
% input:
%   SDM: numSamples by numSamples float matrix, self-distance matrix
%   threshold: float, constant value for thresholding the SDM
% output:
%   SDM_binary: numSamples by numSamples int matrix, binary SDM

function [SDM_binary] = computeBinSdm(SDM, threshold)

  N = size(SDM, 1);
  SDM_binary = zeros(N, N);
  
  for r_idx = 1:N
    for c_idx = 1:N
      SDM_binary(r_idx, c_idx) = SDM(r_idx, c_idx) < threshold;
    end
  end
  
end
