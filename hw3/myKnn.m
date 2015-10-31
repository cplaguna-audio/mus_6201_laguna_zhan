function [estimatedClass] = myKnn(testData, trainData, trainLabel, K)
    num_cols_trainData = size(trainData, 2);
    k_nearest_matrix = zeros(K, 2);
    k_nearest_matrix(:, 2) = 10000;
    
    % Find the k nearest neighbors.
    for col_idx = 1 : num_cols_trainData
        feature_distance = norm(testData - trainData(:, col_idx));

        % Check if current distance is lower than highest minimum.
        [largest_min, largest_min_idx] = max(k_nearest_matrix(:, 2));
        if feature_distance < largest_min
            k_nearest_matrix(largest_min_idx, 2) = feature_distance;
            k_nearest_matrix(largest_min_idx, 1) = trainLabel(col_idx);
        end
    end

    % Find the majority vote, and predict it.
    unique_k_nearest_labels = unique(k_nearest_matrix(:, 1));
    [count_repeated_labels, ~] = histc(k_nearest_matrix(:, 1), unique_k_nearest_labels);
    max_count = max(count_repeated_labels);
    
    majority_idx = find(count_repeated_labels == max_count);
    % Check for a tie. If there is a tie, break the tie by the minimum
    % average distance from the test point.
    if length(majority_idx) == 1
        estimatedClass = unique_k_nearest_labels(majority_idx);
    else
        best_classes = unique_k_nearest_labels(majority_idx);
        
        % For each majority class, find the average distance from the test
        % point.
        num_best_classes = size(best_classes, 1);
        mean_distance_per_class = zeros(num_best_classes, 1);
        for class_idx = 1:num_best_classes
            cur_class = best_classes(class_idx);
            nearest_indices = find(k_nearest_matrix(:, 1) == cur_class);
            class_distances = k_nearest_matrix(nearest_indices, 2);
            mean_distance_per_class(class_idx) = mean(class_distances);
        end
        [~, tiebreaker_idx] = min(mean_distance_per_class);
        
        % Could still be a tie if two classes have the same average
        % distance from the test point, but let's just arbitrarily pick one
        % of those.
        estimatedClass = best_classes(tiebreaker_idx);
    end
end

    
    
    