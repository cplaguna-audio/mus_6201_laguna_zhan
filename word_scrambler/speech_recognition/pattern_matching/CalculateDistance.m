function distance = CalculateDistance(x, y)
  [distance, path] = DynamicTimeWarping(x, y);
  distance = distance / size(path, 1);
end
