% compute lag distance matrix 
% input:
%   SDM: numSamples by numSamples float matrix, self-distance matrix
% output:
%   R: numSamples by numSamples float matrix, lag-distance matrix
% Note: R should be a triangular matrix, xaxis = time, yaxis = lag
%       for more details, please refer to Figure 2 in the reference
%       "Paulus et al., Audio-based Music Structure Analysis, 2010"

function R = computeLagDistMatrix(SDM)
  N = size(SDM, 1);
  R = zeros(N, N);
  
  for r_idx = 1:N
    for c_idx = 1:r_idx
      R(r_idx, r_idx - c_idx + 1) = SDM(r_idx, c_idx);
    end
  end
  
end
