% TrainWordClassifier: Trains a word-classifier on a dataset.
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
function word_classifier = TrainWordClassifier(train_templates, labels)
  
  % Single template per word.
  word_classifier = struct();
  
  number_datasets = size(train_templates, 2);
  word_classifier.templates = {};
  word_classifier.labels = {};
  
  for dataset_idx = 1:number_datasets
    word_classifier.templates = [word_classifier.templates; train_templates(:, dataset_idx)];
    word_classifier.labels = [word_classifier.labels; labels];
  end

  num_features = size(word_classifier.templates{1}, 2);
  
  word_classifier.z_score_means = zeros(1, 1);
  word_classifier.z_score_vars = zeros(1, 1);
  
  % Calculate whitening variables per feature (z-score whitening).
  z_score_means = zeros(num_features, 1);
  z_score_vars = zeros(num_features, 1);
  
  number_templates = size(word_classifier.templates, 1);
  for template_idx = 1:number_templates
    cur_template = word_classifier.templates{template_idx};

    z_score_means = z_score_means + mean(cur_template).';
    z_score_vars = z_score_vars + std(cur_template).';
  end
  
  z_score_means = z_score_means ./ number_templates;
  z_score_vars = z_score_vars ./ number_templates;
  z_score_vars(z_score_vars < 0.01) = 0.01;
  
  word_classifier.z_score_means = z_score_means;
  word_classifier.z_score_vars = z_score_vars;
  
  % Apply whitening.
  number_templates = size(word_classifier.templates, 1);
  for template_idx = 1:number_templates
    cur_template = word_classifier.templates{template_idx};

    num_blocks = size(cur_template, 1);
    for block_idx = 1:num_blocks
      cur_feature_vector = cur_template(block_idx, :);
      cur_feature_vector = cur_feature_vector - word_classifier.z_score_means.';
      cur_feature_vector = cur_feature_vector ./ word_classifier.z_score_vars.';
      cur_template(block_idx, :) = cur_feature_vector;
    end
    word_classifier.templates{template_idx} = cur_template;
  end
  
end
