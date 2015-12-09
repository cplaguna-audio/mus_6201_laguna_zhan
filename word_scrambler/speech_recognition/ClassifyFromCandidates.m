function prediction = ClassifyFromCandidates(word_classifier, template, candidates)
  
  if(isempty(template))
    prediction = '';
    return;
  end

  % Whiten the template.
  num_blocks = size(template, 1);
  for block_idx = 1:num_blocks
    cur_feature_vector = template(block_idx, :);
    cur_feature_vector = cur_feature_vector - word_classifier.z_score_means.';
    cur_feature_vector = cur_feature_vector ./ word_classifier.z_score_vars.';
    
    non_feature_indices = find(word_classifier.z_score_vars == 0);
    cur_feature_vector(non_feature_indices) = 0;
    template(block_idx, :) = cur_feature_vector;
  end
    
  trained_templates = word_classifier.templates;
  num_templates = size(trained_templates, 1);
  distances = zeros(num_templates, 1);
  for template_idx = 1:num_templates
    cur_trained_template = trained_templates{template_idx, 1};
    
    cur_distance = CalculateDistance(template, cur_trained_template);
    distances(template_idx, 1) = cur_distance;
  end
  
  K = 5;
  words = unique(candidates);
  num_words = size(words, 1);
  word_scores = zeros(num_words, 1);
  for w_idx = 1:num_words
    cur_word = words{w_idx};
    cur_distances = distances(strcmp(word_classifier.labels, cur_word));
    cur_distances = sort(cur_distances);
    word_scores(w_idx) = mean(cur_distances(1:K));
  end
  
  [min_distance, min_idx] = min(word_scores);
  disp(['distance: ' num2str(min_distance)]);
  prediction = words{min_idx};
  
  if(min_distance > 0.325)
    prediction = '';
  end
  
end
