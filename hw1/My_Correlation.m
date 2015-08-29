function [y, shifts] = My_Correlation(a, b)
  a_length = size(a, 1);
  b_length = size(b, 1);
  
  y_length = a_length + b_length - 1;
  y = zeros(y_length, 1);
  shifts = zeros(y_length, 1);
  
  a_amount_pad = y_length - a_length;
  a_padding = zeros(a_amount_pad, 1);
  a_padded = [a_padding; a];
  
  b_amount_pad = y_length - b_length;
  b_padding = zeros(b_amount_pad, 1);
  b_padded = [b; b_padding];
  
  for idx = 1:y_length
    current_a = a_padded(idx:y_length);
    current_b = b_padded(1:y_length - (idx - 1));
    y(idx) = sum(current_a .* current_b);
    shifts(idx) = idx - (a_amount_pad + 1);
  end
end
