%% TrainWordClassifier: Trains a word-classifier on a dataset.
%
% word_classifer = TrainWordClassifier(test_datasets, words)
% Trains a classifier which can recognize isolated words - that is, given
% an audio file containing a single spoken word, outputs the recognized
% word (or <> if no match was found).
%
% This function is also responsible for reading audio from the training 
% datasets. This includes:
% 1. Extracting the filepath to the audio file in each database for each
%    word.
% 2. Read the audio files (one by one).
% 3. Extract templates.
% 4. Store templates and labels in a classifier object, which is returned.
%
% We assume that every dataset in |train_datasets| has exactly one audio 
% example for every word in |words|.
%
% Parameters
% train_datasets: Nx1 cell of strings. The names of the databases to use as
%                 the training set.
% words: The words extract templates for.
%
% Return Values
% word_classifier: struct. The classifier. To classify, pass this as the
%                  first object to ClassifyWord(classifier, audio, fs).
% 
% Classifier struct Fields
% object.templates: Nx1 cell of templates. The template is a collection
%                   of features extracted from the audio for the word. The
%                   string is the label.
% object.labels = Nx1 cell of strings. The labels for each template in 
%                 templates (indexes are aligned).
function word_classifier = TrainWordClassifier(train_datasets, words)
  
  % Single template per word.
  word_classifier = struct();
  number_words = size(words, 1);
  word_classifier.templates = cell(number_words, 1);
  word_classifier.labels = cell(number_words, 1);
  number_datasets = size(train_datasets, 1);
  
  template_idx = 1;
  for word_idx = 1:number_words
    current_word = words{word_idx, 1};
    cur_audio_examples = cell(number_datasets, 1);
    cur_sample_rates = zeros(number_datasets, 1);
    
    % Read the audio examples from each dataset.
    for dataset_idx = 1:number_datasets
      cur_dataset = train_datasets{dataset_idx, 1};
      word_path = GetWordPathInDataset(current_word, cur_dataset);
      cur_audio = [];
      cur_fs = -1;
      
      word_mp3_path = [word_path '.mp3'];
      word_wav_path = [word_path '.wav'];
      if (exist(word_mp3_path, 'file') == 2)
        [cur_audio, cur_fs] = audioread(word_mp3_path);
      elseif(exist(word_wav_path, 'file') == 2)
        [cur_audio, cur_fs] = audioread(word_wav_path);
      else
        error([current_word 'not found in database: ' cur_dataset]);
      end
      
      cur_audio_examples{dataset_idx, 1} = cur_audio;
      cur_sample_rates(dataset_idx, 1) = cur_fs;
    end
    
    % Extract templates.
    cur_templates = ExtractTemplate(cur_audio_examples, cur_sample_rates);
    
    % Store templates in struct.
    number_cur_templates = size(cur_templates, 1);
    for cur_template_idx = 1:number_cur_templates
      word_classifier.templates{template_idx} = ...
          cur_templates{cur_template_idx, 1};
      word_classifier.labels{template_idx, 1} = current_word;
      template_idx = template_idx + 1;
    end
  end
  
end
