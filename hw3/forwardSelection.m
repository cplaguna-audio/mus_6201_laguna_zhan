function [selected_features, accuracies] = forwardSelection(features, labels, num_folds, k)
  selected_features = [];
  accuracies = [];
  num_features = size(features, 1);
  remaining_features = (1:num_features).';

  for feature_idx = 1 : num_features
    cur_best_accuracy = -1;
    cur_best_idx = -1;
    num_remaining_features = length(remaining_features);
    for remaining_feature_idx = 1 : num_remaining_features
      candidate_idx = remaining_features(remaining_feature_idx);
      candidate_indices = [candidate_idx; selected_features];
      candidate_features = features(candidate_indices, :);
      cur_accuracy = CrossValidation(candidate_features, labels, num_folds, k);
      if cur_accuracy > cur_best_accuracy
        cur_best_accuracy = cur_accuracy;
        cur_best_idx = candidate_idx;
      end   
    end
    remaining_features = remaining_features(remaining_features~=cur_best_idx);
    selected_features = [selected_features; cur_best_idx];
    accuracies = [accuracies; cur_best_accuracy];
  end
end

