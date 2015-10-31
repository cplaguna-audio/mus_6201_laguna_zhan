% Standard evaluation metrics 
% [precision, recall, fmeasure] = evaluateOnsets(onsetTimeInSec, annotation, deltaTime)
% intput:
%   onsetTimeInSec: n by 1 float vector, detected onset time in second
%   annotation: m by 1 float vector, annotated onset time in second
%   deltaTime: float, maximum time difference for a true positive (millisecond) 
% output:
%   precision: float, fraction of TP from all detected onsets
%   recall: float, fraction of TP from all reference onsets
%   fmeasure: float, the combination of precision and recall

function [precision, recall, fmeasure] = ...
    evaluateOnsets(onsetTimeInSec, annotation, deltaTime)
  
  % Goal: Count true positives, false negatives, false positives.
  % Strategy: Iterate through ground truths. Try to get a close match with
  % an entry in onsetTimeInSec...If we can find a match (within deltaTime),
  % count a true positive and remove that entry from onsetTimeInSec. If
  % not, increment false negatives. Any remaining entries in onsetTimeInSec
  % are counted as false positives.
  
  % Make a copy of onsetTimeInSec, so we can delete from it.
  predictions = onsetTimeInSec;
  num_true_positives = 0;
  num_false_negatives = 0;
  
  num_truths = size(annotation, 1);
  for truth_idx = 1:num_truths
    cur_truth_time_sec = annotation(truth_idx);
    delta_ms = abs(predictions - cur_truth_time_sec) * 1000;
    [min_val, min_idx] = min(delta_ms);
    
    % We found a true positive.
    if(min_val < deltaTime)
      num_true_positives = num_true_positives + 1;
      
      % Delete the prediction from the list of candidate matches.
      predictions(min_idx) = [];
      
    % We found a false negative.
    else
      num_false_negatives = num_false_negatives + 1;
    end
  end
  
  % Any remaining predictions are false positives.
  num_false_positives = size(predictions, 1);
  
  % Calculate precision, recall, and f_measure. Handle 0-valued
  % denominators.
  if((num_true_positives + num_false_positives) == 0)
      precision = 0;
  else
    precision = num_true_positives / ...
                (num_true_positives + num_false_positives);
  end
  
  if((num_true_positives + num_false_negatives) == 0)
      recall = 0;
  else
    recall = num_true_positives / ...
             (num_true_positives + num_false_negatives);
  end  
  
  if(precision + recall == 0)
      fmeasure = 0;
  else
    fmeasure = (2 * precision * recall) / (precision + recall);
  end
end