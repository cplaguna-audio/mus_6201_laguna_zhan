function [selected_features, error_rates] = ForwardSelection(templates, labels)
  selected_features = [];
  error_rates = [];
  num_features = size(templates{1, 1}, 2);
  remaining_features = (1:num_features).';

  for feature_idx = 1 : num_features
    cur_best_error = 1.1;
    cur_best_idx = -1;
    num_remaining_features = length(remaining_features);
    for remaining_feature_idx = 1 : num_remaining_features
      candidate_idx = remaining_features(remaining_feature_idx);
      candidate_indices = [candidate_idx; selected_features];
      
      % Create the candidate templates.
      [num_rows, num_cols] = size(templates);
      candidate_templates = cell(num_rows, num_cols);
      for r_idx = 1:num_rows
        for c_idx = 1:num_cols
          cur_template = templates{r_idx, c_idx};
          cur_template = cur_template(:, candidate_indices);
          candidate_templates{r_idx, c_idx} = cur_template;
        end
      end
      
      cur_error = CrossDatasetValidation(candidate_templates, labels, false)
      if cur_error < cur_best_error
        cur_best_error = cur_error;
        cur_best_idx = candidate_idx;
      end   
    end
    remaining_features = remaining_features(remaining_features~=cur_best_idx);
    selected_features = [selected_features; cur_best_idx];
    error_rates = [error_rates; cur_best_error];
    cur_best_error
  end
end