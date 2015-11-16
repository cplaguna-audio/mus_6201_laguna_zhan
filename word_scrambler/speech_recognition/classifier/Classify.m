function prediction = Classify(word_classifier, template)
  
  % Whiten the template.
  num_blocks = size(template, 1);
  for block_idx = 1:num_blocks
    cur_feature_vector = template(block_idx, :);
    cur_feature_vector = cur_feature_vector - word_classifier.z_score_means.';
    cur_feature_vector = cur_feature_vector ./ word_classifier.z_score_vars.';
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
  
  [min_distance, min_idx] = min(distances);
  % disp(['  Best distance: ' num2str(min_distance)]);
  % disp(['  Average distance: ' num2str(mean(distances))]);
  prediction = word_classifier.labels{min_idx};
end
