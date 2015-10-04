function prediction = Classify(word_classifier, audio, fs)
  new_template = ExtractTemplate({audio}, {fs});
  new_template = new_template{1, 1};
  
  trained_templates = word_classifier.templates;
  num_templates = size(trained_templates, 1);
  distances = zeros(num_templates, 1);
  for template_idx = 1:num_templates
    cur_trained_template = trained_templates{template_idx, 1};
    cur_distance = CalculateDistance(new_template, cur_trained_template);
    distances(template_idx, 1) = cur_distance;
  end
  
  [~, min_idx] = min(distances);
  prediction = word_classifier.labels(min_idx);
end
