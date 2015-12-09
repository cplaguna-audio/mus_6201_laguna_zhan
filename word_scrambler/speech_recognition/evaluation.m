function evaluation  
  DEBUG = true;

  datasets = {'jonny_big'; 'chris_big'; 'avrosh_big'; 'brandon_big'; ...
              'rithesh_big'; 'shi_big'; 'chih_big'; 'lea_big'; ...
              'ying_big' }; 
  num_datasets = size(datasets, 1);
%   datasets = {'manual/chris_big'; 'manual/chris_small'};

  % The words in our dataset.
%   words = GetSharedWords('../dataset/good_words.txt', datasets);
%   words = words(1:55);
%   [templates, labels] = GetWordTemplates(datasets, words);
%   error_rates = CrossDatasetValidation(templates, labels, 5, DEBUG);
%   disp(['  Error rate: ' num2str(mean(error_rates)) '.']);
  
  Ks = [5];

  scramble_path = '../game_engine/scrambles/';
  NUM_SCRAMBLES = 15;
  error_rates = zeros(NUM_SCRAMBLES, num_datasets);
  num_scramble_words = zeros(NUM_SCRAMBLES, 1);
  for k_idx = 1:length(Ks)
    cur_k = Ks(k_idx);
    for scramble_idx = 1:NUM_SCRAMBLES
      cur_file = ['scramble' num2str(scramble_idx - 1) '.txt'];
      cur_path = [scramble_path cur_file];
      cur_scramble_words = GetSharedWords(cur_path, datasets);
      num_scramble_words(scramble_idx) = length(cur_scramble_words);

      [templates, labels] = GetWordTemplates(datasets, cur_scramble_words);
      cur_errors = CrossDatasetValidation(templates, labels, cur_k, DEBUG);
      error_rates(scramble_idx, :) = cur_errors;
    end
    
    disp(['K: ' num2str(cur_k)]);
    for scramble_idx = 1:NUM_SCRAMBLES
      fprintf('Scramble %d\n-----------\nBy dataset -  ', scramble_idx);
      for dataset_idx = 1:num_datasets
        fprintf('%d: %0.4f, ', dataset_idx, error_rates(scramble_idx, dataset_idx));
      end
      scramble_error = mean(error_rates(scramble_idx, :));
      cur_num_words = num_scramble_words(scramble_idx);
      fprintf('\nAverage error: %0.4f, Num words in scramble: %d\n\n', scramble_error, cur_num_words);  
    end
    fprintf('Errors by Dataset\n-----------------\n');
    for dataset_idx = 1:num_datasets
      dataset_error = mean(error_rates(:, dataset_idx));
      fprintf('%d: %0.4f, ', dataset_idx, dataset_error);
    end
    fprintf('\n\n');
    mean_error = mean(mean(error_rates));
    fprintf('Mean Error: %0.4f\n\n\n', mean_error);
  end
    
end

function [templates, labels] = GetWordTemplates(datasets, words)
  number_words = size(words, 1);
  number_datasets = size(datasets, 1);

  templates = cell(number_words, number_datasets);
  labels = cell(number_words, 1);
  
  for word_idx = 1:number_words
    current_word = words{word_idx, 1};
    cur_audio_examples = cell(number_datasets, 1);
    cur_sample_rates = zeros(number_datasets, 1);
    
    cur_templates = {};
    % Read the audio examples from each dataset.
    for dataset_idx = 1:number_datasets
      cur_dataset = datasets{dataset_idx, 1};
      cur_template_path = GetFeaturePath(current_word, cur_dataset);
      cur_template_path = [cur_template_path current_word '.txt'];
      
      fid = fopen(cur_template_path);
      if all(fgetl(fid) == -1)
        cur_template = [];
      else
        cur_template = dlmread(cur_template_path);
      end
      fclose(fid);
      
      cur_templates{dataset_idx} = cur_template;
    end
    
    templates(word_idx, :) = cur_templates;   
    labels{word_idx} = current_word;
  end
end