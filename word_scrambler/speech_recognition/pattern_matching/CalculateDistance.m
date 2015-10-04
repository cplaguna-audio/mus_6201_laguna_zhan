function distance = CalculateDistance(x, y)
  num_x_blocks = size(x, 1);
  num_y_blocks = size(y, 1);
  
  x_filters = x(floor(num_x_blocks / 2), :);
  y_filters = y(floor(num_y_blocks / 2), :);
  
  distance = norm(x_filters - y_filters, 'fro');
end
