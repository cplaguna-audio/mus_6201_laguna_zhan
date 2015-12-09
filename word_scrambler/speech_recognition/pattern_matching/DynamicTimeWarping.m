function [path, accumulated_distance] = DynamicTimeWarping(distance_matrix)
  LEFT = 1;
  UP = 2;
  DIAG = 3;
  [length_x, length_y] = size(distance_matrix);


  accumulated_distance = zeros(length_x, length_y);
  direction = zeros(length_x, length_y);
  
  % Fill out the first row and first column with the only (optimal) path
  % distances.
  first_column_distance = 0;
  for x_idx = 1:length_x
     first_column_distance = first_column_distance + distance_matrix(x_idx, 1);
     accumulated_distance(x_idx, 1) = first_column_distance;
     direction(x_idx, 1) = UP;
  end
  
  first_row_distance = 0;
  for y_idx = 1:length_y
    first_row_distance = first_row_distance + distance_matrix(1, y_idx);
    accumulated_distance(1, y_idx) = first_row_distance;
    direction(1, y_idx) = LEFT;
  end

  % Fill out remaining entries in the matrix.
  for x_idx = 2:length_x
    for y_idx = 2:length_y
      from_left = accumulated_distance(x_idx, y_idx - 1);
      from_up = accumulated_distance(x_idx - 1, y_idx);
      from_diagonal = accumulated_distance(x_idx - 1, y_idx - 1);
      
      [past_distance, cur_direction] = min([from_left from_up from_diagonal]);
      accumulated_distance(x_idx, y_idx) = past_distance + distance_matrix(x_idx, y_idx);
      direction(x_idx, y_idx) = cur_direction;
    end
  end
  
  max_path_length = length_x + length_y - 2;
  path = zeros(max_path_length, 2);
  cur_x = length_x;
  cur_y = length_y;
  cur_idx = 1;
  path(cur_idx, :) = [cur_x, cur_y];
  cur_idx = cur_idx + 1;
  while(~(cur_x == 1 && cur_y == 1))
    cur_direction = direction(cur_x, cur_y);
    if(cur_direction == UP)
      cur_x = cur_x - 1;
    elseif(cur_direction == LEFT)
      cur_y = cur_y - 1;
    elseif(cur_direction == DIAG)
      cur_x = cur_x - 1;
      cur_y = cur_y - 1;
    else
      error('Bad direction.');
    end
    path(cur_idx, :) = [cur_x, cur_y];
    cur_idx = cur_idx + 1;
  end

  path = flipud(path(1:cur_idx - 1, :));

% ==============================================

%   length_x = size(x, 1);
%   length_y = size(y, 1);
%   LEFT = 1;
%   UP = 2;
%   DIAG = 3;
% 
%   accumulated_distance = zeros(length_x, length_y);
%   direction = zeros(length_x, length_y);
%   
%   % Fill out the first row and first column with the only (optimal) path
%   % distances.
%   first_column_distance = 0;
%   for x_idx = 1:length_x
%      first_column_distance = first_column_distance + ...
%                              CalculateVectorDistance(x(x_idx, :), y(1, :));
%      accumulated_distance(x_idx, 1) = first_column_distance;
%      direction(x_idx, 1) = UP;
%   end
%   
%   first_row_distance = 0;
%   for y_idx = 1:length_y
%     first_row_distance = first_row_distance + ...
%                          CalculateVectorDistance(x(1, :), y(y_idx, :));
%     accumulated_distance(1, y_idx) = first_row_distance;
%     direction(1, y_idx) = LEFT;
%   end
% 
%   % Fill out remaining entries in the matrix.
%   for x_idx = 2:length_x
%     for y_idx = 2:length_y
%       from_left = accumulated_distance(x_idx, y_idx - 1);
%       from_up = accumulated_distance(x_idx - 1, y_idx);
%       from_diagonal = accumulated_distance(x_idx - 1, y_idx - 1);
%       
%       [past_distance, cur_direction] = min([from_left from_up from_diagonal]);
%       accumulated_distance(x_idx, y_idx) = past_distance + CalculateVectorDistance(x(x_idx, :), y(y_idx, :));
%       direction(x_idx, y_idx) = cur_direction;
%     end
%   end
%   
%   distance = accumulated_distance(end, end);
%   max_path_length = length_x + length_y - 2;
%   path = zeros(max_path_length, 2);
%   cur_x = length_x;
%   cur_y = length_y;
%   cur_idx = 1;
%   path(cur_idx, :) = [cur_x, cur_y];
%   cur_idx = cur_idx + 1;
%   while(~(cur_x == 1 && cur_y == 1))
%     cur_direction = direction(cur_x, cur_y);
%     if(cur_direction == UP)
%       cur_x = cur_x - 1;
%     elseif(cur_direction == LEFT)
%       cur_y = cur_y - 1;
%     elseif(cur_direction == DIAG)
%       cur_x = cur_x - 1;
%       cur_y = cur_y - 1;
%     else
%       error('Bad direction.');
%     end
%     path(cur_idx, :) = [cur_x, cur_y];
%     cur_idx = cur_idx + 1;
%   end
% 
%   path = flipud(path(1:cur_idx - 1, :));
end

