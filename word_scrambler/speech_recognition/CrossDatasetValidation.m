function [error_rate] = CrossDatasetValidation(templates, labels, debug)
  num_folds = size(templates, 2);
  num_labels = size(labels, 1);
  % Loop through all folds.
  for fold_idx = 1:num_folds
    test_templates = templates(:, fold_idx);
    train_indices = 1:num_folds;
    train_indices(fold_idx) = [];
    train_templates = templates(:, train_indices);

    % Train the classifier.
    word_classifier = TrainWordClassifier(train_templates, labels);
    
    num_correct = 0;
    % Test each word.
    for word_idx = 1:num_labels
      cur_test_template = test_templates{word_idx};
      truth_word = labels{word_idx};
      predicted_word = Classify(word_classifier, cur_test_template);
      if(debug == true)
        disp(['Predicting word ' truth_word '...']); 
        disp(['  Prediction: *' predicted_word '*.']);  
      end
      
      if(strcmp(truth_word, predicted_word))
        num_correct = num_correct + 1;
      end
    end

    current_error_rate = 1 - (num_correct / num_labels);
    error_rates(fold_idx) = current_error_rate;
    disp(['Error rate for test dataset ' num2str(fold_idx) ': ' ...
          num2str(current_error_rate * 100) '%']);
  end
  error_rate = mean(error_rates);
end