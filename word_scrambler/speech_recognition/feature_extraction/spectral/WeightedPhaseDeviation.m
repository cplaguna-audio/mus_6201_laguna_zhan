% Novelty function: weighted phase deviation
% Paper : S. Dixon, 2006, onset detection revisited 
% [nvt] = myWPD(x, windowSize, hopSize)
% input: 
%   x: N by 1 float vector, input signal
%   windowSize: int, number of samples per block
%   hopSize: int, number of samples per hop
% output: 
%   nvt: m by 1 float vector, the resulting novelty function 

function y = WeightedPhaseDeviation(blocked_x, hop_size)    
    
    % Stft.
    freq_x = fft(blocked_x);
    
    % Instantaneous frequency.
    phase_diff_x = PhaseDiff(freq_x, hop_size);
    
    % Calculate weighted phase deviation.
    num_bins = size(phase_diff_x, 1);
    num_blocks = size(phase_diff_x, 2);
    y = zeros(num_blocks, 1);
    for block_idx = 2:num_blocks
        cur_wpd = 0;
        cur_phase_diff_x = phase_diff_x(:, block_idx);
        prev_phase_diff_x = phase_diff_x(:, block_idx - 1);
        cur_phase_second_diff = cur_phase_diff_x - prev_phase_diff_x;
        normalization = 0;
        for bin_idx = 1:floor(num_bins / 2)  
            cur_magnitude = abs(freq_x(bin_idx, block_idx));
            cur_wpd = cur_wpd + abs(cur_magnitude * cur_phase_second_diff(bin_idx));
            normalization = normalization + cur_magnitude;
        end

        cur_wpd = cur_wpd ./ normalization;
        
        % We lost 2 bins doing differences, so shift over by 2 bins.
        y(block_idx) = cur_wpd; 
    end
  
end

