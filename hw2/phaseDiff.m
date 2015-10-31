function phase_diff_x = phaseDiff(freq_x, hopSize)
    phase_x = angle(freq_x);
    [window_size, num_blocks] = size(freq_x);
    phase_diff_x = zeros(window_size, num_blocks - 1);
    
    for block_idx = 2:num_blocks
        cur_phase_x = phase_x(:, block_idx);
        prev_phase_x = phase_x(:, block_idx - 1);
        for bin_idx = 1: window_size
            est_unwrapped_phase_x = ...
                prev_phase_x(bin_idx) + (2 * pi * hopSize * (bin_idx - 1) / window_size);
            phase_offset = wrapPhase(cur_phase_x(bin_idx) - est_unwrapped_phase_x);
            unwrapped_phase_x = phase_offset + est_unwrapped_phase_x;
            phase_diff_x(bin_idx, block_idx - 1) = unwrapped_phase_x - prev_phase_x(bin_idx);
        end
    end
    
end

function wrapped_phase = wrapPhase(unwrapped_phase)
  unwrapped_phase = unwrapped_phase + pi;
  wrapped_phase = mod(unwrapped_phase, 2 * pi);
  wrapped_phase = wrapped_phase - pi;
end