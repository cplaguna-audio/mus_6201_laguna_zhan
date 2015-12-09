function evaluation  
  DEBUG = true;

  datasets = {'jonny_big'; 'chris_big'; 'avrosh_big'; 'brandon_big'; ...
              'rithesh_big'; 'shi_big'; 'chih_big'; 'lea_big'; ...
              'ying_big' }; 
            

  % The words in our dataset.
  words = GetSharedWords('../dataset/good_words.txt', datasets);
  words = words(1:55);
  [templates, labels] = GetWordTemplates(datasets, words);
  [selected_features, error_rates] = ForwardSelection(templates, labels);
  selected_features;
  error_rates;
  
  save('feature_selection.mat', 'selected_features', 'error_rates');
  
  
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
    
    % Read the audio examples from each dataset.
    for dataset_idx = 1:number_datasets
      cur_dataset = datasets{dataset_idx, 1};
      [cur_audio, cur_fs] = LoadWordAudio(current_word, cur_dataset);
      
      cur_audio_examples{dataset_idx, 1} = cur_audio;
      cur_sample_rates(dataset_idx, 1) = cur_fs;
    end
    
    % Extract templates.
    disp(['Current word: ' current_word]);
    cur_templates = ExtractTemplate(cur_audio_examples, cur_sample_rates);
    templates(word_idx, :) = cur_templates.';   
    labels{word_idx} = current_word;
  end
end