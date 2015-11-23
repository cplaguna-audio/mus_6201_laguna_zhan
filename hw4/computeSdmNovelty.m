% compute novelty function from Self-distance matrix
% input:
%   SDM: float N by N matrix, self-distance matrix
%   L: int, size of the checkerboard kernel (L by L) preferably power of 2
% output:
%   nvt: float N by 1 vector, audio segmentation novelty function 

function [nvt] = computeSdmNovelty(SDM, L)
  num_blocks = size(SDM, 1) - L + 1;
  nvt = zeros(num_blocks, 1);
  checker = ones(L/2, L/2);
  checkerboard = [checker     , -1 * checker; ...
                  -1 * checker, checker];
                
  for idx = 1:num_blocks
    block = SDM(idx:idx + L - 1, idx:idx + L - 1);
    nvt(idx) = sum(sum(block .* checkerboard));
  end
end
