% compute self-distance matrix
% input:
%   featureMatrix: numFeatures by numSamples float matrix, feature matrix
% output:
%   SDM: numSamples by numSamples float matrix, self-distance matrix

function [SDM] = computeSelfDistMat(featureMatrix)
  N = size(featureMatrix, 2);
  SDM = zeros(N, N);

  for c_idx = 1:N
    for r_idx = 1:c_idx
      row_fv = featureMatrix(:, r_idx);
      col_fv = featureMatrix(:, c_idx);
      cur_distance = norm(row_fv - col_fv, 2);
      SDM(r_idx, c_idx) = cur_distance;
      SDM(c_idx, r_idx) = cur_distance;
    end
  end

end


