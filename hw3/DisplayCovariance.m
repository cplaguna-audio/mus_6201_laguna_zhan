clear;
COMPUTE_FEATURES = true;
if(COMPUTE_FEATURES)
  [features, labels] = getMetaData();
else
  load getMetaData.mat
end

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

covariance = MyCovariance(features)
imagesc(abs(covariance));
title('Absolute Value of Covariance Matrix of Features');
