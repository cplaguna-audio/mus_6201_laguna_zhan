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
    word_path = GetAudioPath(word, cur_dataset);
    word_mp3_path = [word_path word '.mp3'];
    word_wav_path = [word_path word '.wav'];
    if ~((exist(word_mp3_path, 'file') == 2) || ...
         (exist(word_wav_path, 'file') == 2))
      is_in_datasets = false;
    end  
  end
end