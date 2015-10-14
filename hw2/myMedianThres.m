%% Adaptive threshold: median filter
% [thres] = myMedianThres(nvt, order, lambda)
% input: 
%   nvt: m by 1 float vector, the novelty function
%   order: int, size of the sliding window in samples
%   lambda: float, a constant coefficient for adjusting the threshold
% output:
%   thres = m by 1 float vector, the adaptive median threshold

function [thres] = myMedianThres(nvt, order, lambda)

  num_samples = size(nvt, 1);
  thres = zeros(num_samples, 1);
  half_width = floor(order / 2);
  for sample_idx = 1:num_samples
    start = max(sample_idx - half_width, 1);
    stop = min(sample_idx + half_width, num_samples);
    
    cur_window = nvt(start:stop);
    thres(sample_idx) = median(cur_window);
  end
  
  thres = thres + lambda;
end