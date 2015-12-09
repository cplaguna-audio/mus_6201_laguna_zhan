function ExtractDatasetFeatures 
  datasets = {'jonny_big'; 'chris_big'; 'avrosh_big'; 'brandon_big'; ...
              'rithesh_big'; 'shi_big'; 'chih_big'; 'lea_big'; ...
              'ying_big' };
  number_datasets = size(datasets, 1);
  
  % all_words = GetSharedWords('../game_engine/scrambles/scramble0.txt', datasets);

  all_words = GetSharedWords('../dataset/dataset_words.txt', datasets);

  number_words = size(all_words, 1);
  for word_idx = 1:number_words
    current_word = all_words{word_idx, 1};
    
    % Read the audio examples from each dataset.
    for dataset_idx = 1:number_datasets
      cur_dataset = datasets{dataset_idx, 1};
      [cur_audio, cur_fs] = LoadWordAudio(current_word, cur_dataset);
      cur_templates = ExtractTemplate({cur_audio}, cur_fs);
      cur_path = [GetFeaturePath(current_word, cur_dataset) current_word '.txt'];
      
      dlmwrite(cur_path, cur_templates{1}, 'precision', 10);
    end
  end  
end
