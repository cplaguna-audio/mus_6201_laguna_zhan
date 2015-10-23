function prediction = Classify(word_classifier, audio, fs)
  new_template = ExtractTemplate({audio}, [fs]);
  new_template = new_template{1, 1};
  
  % Whiten the template.
  num_blocks = size(new_template, 1);
  for block_idx = 1:num_blocks
    cur_feature_vector = new_template(block_idx, :);
    cur_feature_vector = cur_feature_vector - word_classifier.z_score_means.';
    cur_feature_vector = cur_feature_vector ./ word_classifier.z_score_vars.';
    new_template(block_idx, :) = cur_feature_vector;
  end
  
  trained_templates = word_classifier.templates;
  num_templates = size(trained_templates, 1);
  distances = zeros(num_templates, 1);
  for template_idx = 1:num_templates
    cur_trained_template = trained_templates{template_idx, 1};
    cur_distance = CalculateDistance(new_template, cur_trained_template);
    distances(template_idx, 1) = cur_distance;
  end
  
  [~, min_idx] = min(distances);
  prediction = word_classifier.labels{min_idx};
end
