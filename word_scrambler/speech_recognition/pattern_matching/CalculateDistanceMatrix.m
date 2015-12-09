function z = CalculateDistanceMatrix(x, y)

  len_x = size(x, 1);
  len_y = size(y, 1);
  
  z = zeros(len_x, len_y);
  
  for x_idx = 1:len_x
    for y_idx = 1:len_y
      cur_x = x(x_idx, :);
      cur_y = y(y_idx, :);
      z(x_idx, y_idx) = CalculateVectorDistance(cur_x, cur_y);
    end
  end

end

