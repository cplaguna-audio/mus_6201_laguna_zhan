function [accuracy, c_mat] = CrossValidation(data, labels, num_folds, k)
  num_classes = max(labels);
  num_data = size(labels, 1);
  indices_by_class = cell(num_classes, 1);
  
  num_data_per_class = zeros(num_classes, 1);
  for class_idx = 1:num_classes
    indices_in_class = find(labels == class_idx);
    num_data_in_class = size(indices_in_class, 1);
    num_data_per_class(class_idx) = num_data_in_class;
    
    % Randomize the order of these indices.
    perm = randperm(num_data_in_class);
    indices_by_class{class_idx} = indices_in_class(perm);
  end

  max_data_per_class = max(num_data_per_class);
  
  % Reorder the data so that the classes are evenly distributed. This only
  % works if the number of data per class is equal.
  fold_size = ceil(num_data / num_folds);
  data_by_fold = cell(num_folds, fold_size);
  labels_by_fold = zeros(num_folds, fold_size);
  
  fold_idx = 1;
  fold_offsets = ones(num_folds, 1);
  LABEL_IDX = 1;
  FEATURE_IDX = 2;
  cur_data = cell(2, 1);
  for rotation_idx = 1:max_data_per_class
    for class_idx = 1:num_classes
      
      % Make sure we still have data from the current class.
      if(rotation_idx <= num_data_per_class(class_idx));
        cur_class_indices = indices_by_class{class_idx};
        data_idx = cur_class_indices(rotation_idx);
        cur_data{FEATURE_IDX} = data(:, data_idx);
        cur_data{LABEL_IDX} = labels(data_idx); 
        
        cur_fold_offset = fold_offsets(fold_idx);
        
        while(cur_fold_offset > fold_size)
          fold_idx = fold_idx + 1;
          fold_idx = mod(fold_idx - 1, num_folds) + 1;
          cur_fold_offset = fold_offsets(fold_idx);
        end
        
        data_by_fold{fold_idx, cur_fold_offset} = cur_data;
        labels_by_fold(fold_idx, cur_fold_offset) = labels(data_idx);
        fold_offsets(fold_idx) = cur_fold_offset + 1;
      end
    end
    fold_idx = fold_idx + 1;
    fold_idx = mod(fold_idx - 1, num_folds) + 1;
  end
  
  c_mat = zeros(num_classes, num_classes);
  for fold_idx = 1:num_folds
    % Create the test feature_matrix + label_vector.
    test_features = [];
    test_labels = [];
    for data_idx = 1:fold_size
      cur_data = data_by_fold{fold_idx, data_idx};
      if(isempty(cur_data))
        break;
      end
      cur_label = cur_data{LABEL_IDX};
      cur_feature = cur_data{FEATURE_IDX};
      
      test_features = [test_features cur_feature];
      test_labels = [test_labels; cur_label];
    end
    
    % Create the training feature_matrix + label_vector;
    train_features = [];
    train_labels = [];
    for train_fold_idx = 1:num_folds
      if(train_fold_idx == fold_idx)
        continue;
      end
      
      for data_idx = 1:fold_size
        cur_data = data_by_fold{train_fold_idx, data_idx};
        if(isempty(cur_data))
          break;
        end
        
        cur_label = cur_data{LABEL_IDX};
        cur_feature = cur_data{FEATURE_IDX};
        
        train_features = [train_features cur_feature];
        train_labels = [train_labels; cur_label];
      end
    end
    
    % Do the classification for the current fold.
    num_test_data = size(test_labels, 1);
    prediction_labels = zeros(num_test_data, 1);
    for test_idx = 1:num_test_data
      test_feature = test_features(:, test_idx);
      cur_prediction = myKnn(test_feature, train_features, train_labels, k);
      prediction_labels(test_idx) = cur_prediction;
    end
    
    cur_c_mat = confusionmat(test_labels, prediction_labels);   
    c_mat = c_mat + cur_c_mat;
  end
  
  accuracy = trace(c_mat) / sum(sum(c_mat));
end

