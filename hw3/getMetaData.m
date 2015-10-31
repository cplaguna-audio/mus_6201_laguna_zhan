function [features, labels] = getMetaData()
  GENRE_PATH = '../../genres/';
  GENRES = {'country'; 'classical'; 'hiphop'; 'jazz'; 'metal'};
  NUM_FEATURES = 10;
  
  WINDOW_SIZE = 2048;
  HOP_SIZE = 1024;
  
  total_num_files = 0;
  
  num_genres = size(GENRES, 1);
  genre_files = cell(num_genres, 1);
  for genre_idx = 1:num_genres
    cur_genre = GENRES{genre_idx};
    cur_genre_path = [GENRE_PATH cur_genre];
    cur_genre_files = dir(cur_genre_path);
    
    % Remove hidden files.
    cur_genre_files = cur_genre_files(arrayfun(@(x) x.name(1), cur_genre_files) ~= '.');
    cur_genre_files = {cur_genre_files.name}.';
    genre_files{genre_idx} = cur_genre_files;
    total_num_files = total_num_files + size(cur_genre_files, 1);
  end
  
  features = zeros(NUM_FEATURES, total_num_files);
  labels = zeros(total_num_files, 1);
  all_files_idx = 1;
  for genre_idx = 1:num_genres
    cur_label = genre_idx;
    cur_genre = GENRES{genre_idx};
    cur_relative_path = [GENRE_PATH cur_genre];
    cur_genre_files = genre_files{genre_idx};
    
    num_files = size(cur_genre_files, 1);
    
    for genre_file_idx = 1:num_files
      cur_file_path = cur_genre_files{genre_file_idx};
      [cur_audio, fs] = audioread([cur_relative_path '/' cur_file_path]);
      
      cur_features = ExtractFeatures(cur_audio, fs, WINDOW_SIZE, HOP_SIZE);
      features(:, all_files_idx) = cur_features;
      labels(all_files_idx) = cur_label;
      all_files_idx = all_files_idx + 1;
    end
  end
end

