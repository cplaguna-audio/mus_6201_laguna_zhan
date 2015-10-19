function distance = DynamicTimeWarping(x, y)
  length_x = size(x, 1);
  length_y = size(y, 1);

  accumulated_distance = zeros(length_x, length_y);
  
  % Fill out the first row and first column with the only (optimal) path
  % distances.
  first_column_distance = 0;
  for x_idx = 1:length_x
     first_column_distance = first_column_distance + ...
                             CalculateVectorDistance(x(x_idx, :), y(1, :));
     accumulated_distance(x_idx, 1) = first_column_distance; 
  end
  
  first_row_distance = 0;
  for y_idx = 1:length_y
    first_row_distance = first_row_distance + ...
                         CalculateVectorDistance(x(1, :), y(y_idx, :));
    accumulated_distance(1, y_idx) = first_row_distance;
  end

  % Fill out remaining entries in the matrix.
  for x_idx = 2:length_x
    for y_idx = 2:length_y
      from_left = accumulated_distance(x_idx, y_idx - 1);
      from_down = accumulated_distance(x_idx - 1, y_idx);
      from_diagonal = accumulated_distance(x_idx - 1, y_idx - 1);
      accumulated_distance(x_idx, y_idx) = ...
          min([from_left from_down from_diagonal]) + ...
          CalculateVectorDistance(x(x_idx, :), y(y_idx, :));
    end
  end
  
  distance = accumulated_distance(end, end);
end

