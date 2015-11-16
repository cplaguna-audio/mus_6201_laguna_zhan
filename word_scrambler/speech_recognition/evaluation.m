function evaluation  
  DEBUG = true;

  datasets = {'chris_2'; 'chris'; 'ashis'}; % 'lingoes'; 

  % The words in our dataset.
  [words, unused_words] = GetSharedWords('../dataset/dataset_words.txt', datasets);
  words = words(1:15);

  num_words = size(words, 1);
  num_folds = size(datasets, 1);
  error_rates = zeros(num_folds, 1);
  
  [templates, labels] = GetWordTemplates(datasets, words);
  % [selected_features, accuracies] = ForwardSelection(templates, labels);
  
  % word = 'rob';
  word_idx = 2;
  figure();
  ax1 = subplot(3,1,1);
  imagesc(templates{word_idx, 1})
  ax2 = subplot(3,1,2);
  imagesc(templates{word_idx, 2})
%   ax3 = subplot(3,1,3);
%   imagesc(templates{word_idx, 3})
  linkaxes([ax1, ax2])

  error_rate = CrossDatasetValidation(templates, labels, DEBUG);
  disp(['Error rate: ' num2str(error_rate) '.']);
end

% Returns a list (Nx1 cell of strings) of the words from the |word_file|
% file for which there exists a corresponding audio file in every dataset.
function [shared_words, unused_words] = GetSharedWords(word_file, datasets)
  candidate_words = {};
  shared_words = {};
  unused_words = {};
  
  % Parsing file for words.
  fid = fopen(word_file);

  new_word = fgetl(fid);
  while ischar(new_word)
    candidate_words = [candidate_words; new_word];
    new_word = fgetl(fid);
  end
  
  fclose(fid);
  
  num_words = size(candidate_words, 1);
  for idx = 1:num_words
    current_candidate = candidate_words{idx};
    if IsWordInDatasets(current_candidate, datasets)
      shared_words = [shared_words; current_candidate];
    else 
      unused_words = [unused_words; current_candidate];
    end
  end
  
end

% Checks if the dataset contains the given word.
function is_in_datasets = IsWordInDatasets(word, datasets)
  num_datasets = size(datasets, 1);
  is_in_datasets = true;
  for idx = 1:num_datasets
    cur_dataset = datasets{idx};
    word_path = GetWordPathInDataset(word, cur_dataset);
    word_mp3_path = [word_path '.mp3'];
    word_wav_path = [word_path '.wav'];
    if ~((exist(word_mp3_path, 'file') == 2) || ...
         (exist(word_wav_path, 'file') == 2))
      is_in_datasets = false;
    end  
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
    
    % Read the audio examples from each dataset.
    for dataset_idx = 1:number_datasets
      cur_dataset = datasets{dataset_idx, 1};
      [cur_audio, cur_fs] = LoadWordAudio(current_word, cur_dataset);
      
      cur_audio_examples{dataset_idx, 1} = cur_audio;
      cur_sample_rates(dataset_idx, 1) = cur_fs;
    end
    
    % Extract templates.
    cur_templates = ExtractTemplate(cur_audio_examples, cur_sample_rates);
    templates(word_idx, :) = cur_templates.';   
    labels{word_idx} = current_word;
  end
end