clear;
disp('Evaluating Genre Classification System.'); fprintf('\n');
disp('Class Names:');
disp('Class 1: Country');
disp('Class 2: Classical');
disp('Class 3: Hip Hop');
disp('Class 4: Jazz');
disp('Class 5: Metal'); fprintf('\n');
disp('Feature Names:');
disp('1. Spectral Centroid Mean');
disp('2. Spectral Centroid Standard Deviation');
disp('3. Spectral Flux Mean');
disp('4. Spectral Flux Standard Deviation');
disp('5. Spectral Crest Mean');
disp('6. Spectral Crest Standard Deviation');
disp('7. Zero Crossing Rate Mean');
disp('8. Zero Crossing Rate Standard Deviation');
disp('9. Max Envelope Mean');
disp('10. Max Envelope Standard Deviation'); fprintf('\n');

COMPUTE_FEATURES = true;
if(COMPUTE_FEATURES)
  [features, labels] = getMetaData();
else
  load getMetaData.mat
end

NUM_FOLDS = 10;
Ks = [1 3 7];

% z-score whitening.
[num_features, num_data] = size(features);

% Calculate whitening variables per feature (z-score whitening).
z_score_means = mean(features.').';
z_score_vars = std(features.').';

% Apply whitening.
for feature_idx = 1:num_features
  cur_features = features(feature_idx, :);
  cur_features = (cur_features - z_score_means(feature_idx)) ./ ...
                 z_score_vars(feature_idx);
  features(feature_idx, :) = cur_features;
end

num_ks = length(Ks);
for k_idx = 1:num_ks
  cur_k = Ks(k_idx);
  
  disp(['************* K = ' num2str(cur_k) ' *************']);
  
  % Do forward selection.
  [selected_features, accuracies] = forwardSelection(features, labels, NUM_FOLDS, cur_k);
  
  disp(['Features ranked best to worst for K = ' num2str(cur_k) ':']);
  disp(selected_features.'); 
  
  % Plot forward selection.
  figure()
  plot(accuracies);
  title(['Forward Selection for K = ' num2str(cur_k)]);
  xlabel('Number of features');
  ylabel('Accuracy');

  % Show confusion matrix for the best features.
  [~, max_idx] = max(accuracies);
  best_feature_indices = selected_features(1:max_idx);
  best_features = features(best_feature_indices, :);

  [accuracy, confusion_mat] = CrossValidation(best_features, labels, NUM_FOLDS, cur_k);
  disp(['Accuracy for K = ' num2str(cur_k) ': ' num2str(accuracy, 6)]);
  disp(['Confusion Matrix for K = ' num2str(cur_k) ':']);
  disp(confusion_mat);

end
