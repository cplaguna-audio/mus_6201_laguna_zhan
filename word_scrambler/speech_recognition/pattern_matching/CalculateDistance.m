function distance = CalculateDistance(x, y)

  if(isempty(x) || isempty(y))
    distance = 999999;
    return;
  end

  distance_matrix = CalculateDistanceMatrix(x, y);
  [path, distances] = DynamicTimeWarping(distance_matrix);
  
  path_length = size(path, 1);
  start_idx = 1;
  stop_idx = path_length;
  for path_idx = 1:path_length
    if(path(path_idx, 1) ~= 1 && path(path_idx, 2) ~= 1)
      start_idx = path_idx - 1;
      break;
    end
  end
  
  x_len = size(x, 1);
  y_len = size(y, 1);
  for path_idx = fliplr(1:path_length)
    if(path(path_idx, 1) ~= x_len && path(path_idx, 2) ~= y_len)
      stop_idx = path_idx + 1;
      break;
    end
  end
  
  if(start_idx == 1)
    begin_dist = 0;
  else
    begin_x = path(start_idx - 1, 1);
    begin_y = path(start_idx - 1, 2);
    begin_dist = distances(begin_x, begin_y);
  end
  
  stop_x = path(stop_idx, 1);
  stop_y = path(stop_idx, 2);
  stop_dist = distances(stop_x, stop_y);
  
  distance = stop_dist - begin_dist;
  distance = distance / (stop_idx - (start_idx - 1));
end