function classifier = NewScramble(scramble_words)
  disp('Size of scramble_words:');
  scramble_words = scramble_words.';
  disp(size(scramble_words));

  datasets = GetGameDatasets();
  [train_templates, labels] = LoadWordTemplates(datasets, scramble_words);
  classifier = TrainWordClassifier(train_templates, labels);
  save_file = GetClassifierFilename();
  save(save_file, 'classifier');
end

function [templates, labels] = LoadWordTemplates(datasets, words)
  number_words = size(words, 1);
  number_datasets = size(datasets, 1);

  templates = cell(number_words, number_datasets);
  labels = cell(number_words, 1);
  
  % Load templates.
  for word_idx = 1:number_words
    current_word = words{word_idx, 1};

    for dataset_idx = 1:number_datasets
      current_dataset = datasets{dataset_idx};
      cur_path = GetFeaturePath(current_word, current_dataset);
      cur_file = [cur_path current_word '.txt'];
      fid = fopen(cur_file);
      if all(fgetl(fid) == -1)
        cur_template = [];
      else
        cur_template = dlmread(cur_file);
      end
      fclose(fid);
      
      templates{word_idx, dataset_idx} = cur_template;   
      labels{word_idx} = current_word;
    end
  end
end
