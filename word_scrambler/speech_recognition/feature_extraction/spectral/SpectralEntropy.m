function y = SpectralEntropy(x_mag)
  num_bins = size(x_mag, 1);
  K = num_bins / 2;  
  sum_x = sum(x_mag(1:K));
  if(sum_x == 0)
    y = 0;
    return;
  end

  % Normalize the spectrum (probability distribution).
  x_mag = x_mag ./ sum_x;
  
  y = 0;
  for bin_idx = 1:K
    prob_i = x_mag(bin_idx);
    if(prob_i ~= 0)
      y = y - (prob_i * (log(prob_i) / log(K)) );
    end
  end
  
end

