%% Evaluate the results
% [err_rms] = myEvaluation(est, ann)
% Input:
%   estimation = numBlocks*1 float vector, estimated pitch (Hz) per block   
%   annotation = numBlocks*1 float vector, annotated pitch (Hz) per block
% Output:
%   errCent_rms = float, rms of the difference between estInMidi and annInMidi 
%                 Note: please exclude the blocks when ann(i) == 0
% CW @ GTCMT 2015

function [errCent_rms] = myEvaluation(estimation, annotation)
  CENTS_PER_SEMITONE = 100;
  
  % If number of estimates differs from number of annotations, crop to the
  % smaller number.
  number_estimates = size(estimation, 1);
  number_annotations = size(annotation, 1);
  if(number_estimates > number_annotations)
    estimation = estimation(1:number_annotations);
  elseif(number_annotations > number_estimates)
    annotation = annotation(1:number_estimates);
  end
  
  valid_indices = find(annotation ~= 0);
  
  valid_estimation = estimation(valid_indices);
  valid_estimation = FrequencyToMidi(valid_estimation);
  
  valid_annotation = annotation(valid_indices);
  valid_annotation = FrequencyToMidi(valid_annotation);
  
  error_cent = abs(valid_estimation - valid_annotation) .* ...
               CENTS_PER_SEMITONE;
             
  errCent_rms = rms(error_cent);
end