function [distance, path] = DynamicTimeWarping(x, y)
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
  
  % Find the warped-path, backwards.
  DIAG_IDX = 1;
  LEFT_IDX = 2;
  DOWN_IDX = 3;
  
  impossible_to_reach = max(max(accumulated_distance)) + 1;
  path = [];
  cur_x = length_x;
  cur_y = length_y;
  path = [[cur_x cur_y]; path];
  size_path = 0;
  while(~(cur_x == 1 && cur_y == 1))
    size_path = size_path +1;
    if(cur_x > 1)
      from_left = accumulated_distance(cur_x - 1, cur_y);
    else
      from_left = impossible_to_reach;
    end
    
    if(cur_y > 1)
      from_down = accumulated_distance(cur_x, cur_y - 1);
    else
      from_down = impossible_to_reach;
    end
    
    if(cur_x > 1 & cur_y > 1)
      from_diagonal = accumulated_distance(cur_x - 1, cur_y - 1);
    else
      from_diagonal = impossible_to_reach;
    end
    
    [~, min_idx] = min([from_diagonal from_left from_down]);

    % From diagonal is best path.
    if(min_idx == DIAG_IDX)
      cur_x = cur_x - 1;
      cur_y = cur_y - 1;
      path = [[cur_x, cur_y]; path];
     
    % From left is best path.
    elseif(min_idx == LEFT_IDX)
      cur_x = cur_x - 1;
      path = [[cur_x, cur_y]; path];
    
    % From down is best path.
    elseif(min_idx == DOWN_IDX)
      cur_y = cur_y - 1;
      path = [[cur_x, cur_y]; path];
 
    else
      error('Something strange happened while calculating the warp path.');
    end
  end
end

