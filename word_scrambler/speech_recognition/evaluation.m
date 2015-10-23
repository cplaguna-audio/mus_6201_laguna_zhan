function evaluation
  DEBUG = false;

  datasets = {'google'; 'lingoes'; 'merriam_webster'};

  % The words in our dataset.
  [words, unused_words] = GetSharedWords('../dataset/dataset_words.txt', datasets);

  num_words = size(words, 1);
  num_folds = size(datasets, 1);
  error_rates = zeros(num_folds, 1);

  % Loop through all folds.
  for fold_idx = 1:num_folds
    testing_dataset = datasets{fold_idx};
    training_datasets = {datasets{1:fold_idx - 1} datasets{fold_idx + 1:end}}';

    % Train the classifier.
    word_classifier = TrainWordClassifier(training_datasets, words);
    
    num_correct = 0;
    % Test each word.
    for word_idx = 1:num_words
      if(mod(word_idx, 2) == 1)
        % disp(word_idx);
      end
      
      truth_word = words{word_idx, 1};
      first_letter = truth_word(1);
      word_audio = 0;
      word_fs = 0;
      
      word_mp3_path = ['../dataset/' testing_dataset '/' first_letter '/' ...
                       truth_word '.mp3'];
      word_wav_path = ['../dataset/' testing_dataset '/' first_letter '/' ...
                       truth_word '.wav'];
                     
      if exist(word_mp3_path, 'file') == 2
        [word_audio, word_fs] = audioread(word_mp3_path);
      elseif (exist(word_wav_path, 'file') == 2)
        [word_audio, word_fs] = audioread(word_wav_path);
      else
        error(['Could not find word: ' truth_word ' in dataset: ' ...
               training_dataset '.']);
      end
      
      % Normalize Audio
      if(DEBUG == true)
        disp(['Classifying audio for the word *' truth_word '*.']);  
      end
      
      predicted_word = Classify(word_classifier, word_audio, word_fs);
      if(DEBUG == true)
        disp(['Prediction: *' predicted_word '*.']);  
      end
      
      if(strcmp(truth_word, predicted_word))
        num_correct = num_correct + 1;
      end
    end

    current_error_rate = 1 - (num_correct / num_words);
    error_rates(fold_idx) = current_error_rate;
    disp(['Error rate for test dataset ' datasets{fold_idx} ': ' ...
          num2str(current_error_rate * 100) '%']);
  end
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
