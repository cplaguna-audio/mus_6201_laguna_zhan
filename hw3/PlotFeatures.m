clear;

COMPUTE_FEATURES = true;
if(COMPUTE_FEATURES)
  [features, labels] = getMetaData();
else
  load getMetaData.mat
end

feature_x_labels = {'Mean Spectral Centrod'; 'Mean Spectral Flux'; 'Mean Maximum Envelope'; ...
                    'STD Zero Crossing Rate'; 'STD Spectral Centroid'};
feature_y_labels = {'Mean Spectral Crest'; 'Mean Zero Crossing Rate'; 'STD Maximum Envelope'; ...
                    'STD Spectral Crest'; 'STD Spectral Flux'};
feature_pairs = [1 5; 3 7; 9 10; 8 6; 2 4];

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

% Plot features.
num_pairs = size(feature_pairs, 1);
for pair_idx = 1:num_pairs
  figure();
  x_feature_idx = feature_pairs(pair_idx, 1);
  y_feature_idx = feature_pairs(pair_idx, 2);
  
  x_features = features(x_feature_idx, :);
  y_features = features(y_feature_idx, :);
  gscatter(x_features, y_features, labels, [], [], 20);
  title('1: Country, 2: Classical, 3: Hip Hop, 4: Jazz, 5: Metal');
  xlabel(feature_x_labels{pair_idx});
  ylabel(feature_y_labels{pair_idx});
end