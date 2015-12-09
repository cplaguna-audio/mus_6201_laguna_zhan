function mfccs = MFCC(x, number_coeffs, fs)
  NUMBER_BANDS = 20;
  LOW_CUTOFF_HZ = 300;
  HIGH_CUTOFF_HZ = 7000;
    
  N = size(x, 1);
  x_pre = zeros(size(x));
  
  % Premphasis
  for idx = 2:N
    x_pre(idx) = x(idx) - (0.95 * x(idx - 1));
  end
  
  window = hann(N);
  x_windowed = x_pre .* window;
  x_freq = fft(x_windowed);
  x_mag = abs(x_freq);
  
  filter_bank = TriangularMelBands(NUMBER_BANDS, N, LOW_CUTOFF_HZ, HIGH_CUTOFF_HZ, fs);
  mel_bands = filter_bank * x_mag;
  mel_log_bands = log(mel_bands);
  mel_log_bands(mel_bands == 0) = 0;
  mfccs = dct(mel_log_bands);
  mfccs = mfccs(2:number_coeffs + 1);
end

% Filterbank is a matrix of row vectors, which are weights to be used
% against a magnitude spectrum.
function filter_bank = TriangularMelBands(number_bands, block_size, ...
                                           low_cutoff_hz, high_cutoff_hz, fs)
                                         
  freq_resolution = fs / block_size;
  
  filter_bank = zeros(number_bands, block_size);
  bottom = HzToMel(low_cutoff_hz);
  top = HzToMel(high_cutoff_hz);
  
  number_points = number_bands + 2;
  points_mel = linspace(bottom, top, number_points);
  points_hz = MelToHz(points_mel);
  
  for band_idx = 1:number_bands
    left_cutoff_hz = points_hz(band_idx);
    left_cutoff_bin = round(left_cutoff_hz / freq_resolution) + 1;
    
    center_hz = points_hz(band_idx + 1);
    center_bin = round(center_hz / freq_resolution) + 1;

    right_cutoff_hz = points_hz(band_idx + 2);
    right_cutoff_bin = round(right_cutoff_hz / freq_resolution) + 1;
    
    % First, construct the left line.
    left_width = center_bin - left_cutoff_bin;
    left_slope = 1 / left_width;
    for bins_from_center = 1:left_width - 1
      cur_bin = center_bin - bins_from_center;
      cur_value = 1 - (left_slope * bins_from_center);
      filter_bank(band_idx, cur_bin) = cur_value;
    end
    
    filter_bank(band_idx, center_bin) = 1;
    
    % Next, construct the left line.
    right_width = right_cutoff_bin - center_bin;
    right_slope = 1 / right_width;
    for bins_from_center = 1:right_width - 1
      cur_bin = center_bin + bins_from_center;
      cur_value = 1 - (right_slope * bins_from_center);
      filter_bank(band_idx, cur_bin) = cur_value;
    end
  end
end

function y = MelToHz(x)
  y = 700 * (exp(x / 1127) - 1);
end

function y = HzToMel(x)  
  y = 1127 .* log(1 + (x ./ 700));
end