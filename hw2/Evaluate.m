function [precision, recall, f_measure] = ...
    Evaluate(test_path, windowSize, hopSize, method_str, deltaTime)

  audio_path = [test_path '/audio/'];
  truth_path = [test_path '/ground truth/'];
  audio_files = dir(audio_path);
  audio_files = audio_files(arrayfun(@(x) x.name(1), audio_files) ~= '.');
  
  precision = 0;
  recall = 0;
  f_measure = 0;
  
  num_test_files = size(audio_files, 1);
  for test_file_idx = 1:num_test_files
     [~, file_name] = fileparts(audio_files(test_file_idx).name);

     % file_name
     cur_audio_path = [audio_path file_name '.wav'];
     cur_truth_path = [truth_path file_name '.txt'];
     [test_audio, test_fs] = audioread(cur_audio_path);
     
     % Normalize audio file.
     test_audio = test_audio ./ max(abs(test_audio));
     
     % Calculate the novelty function.
     if(strcmp(method_str, 'flux'))
         nvt = mySpectralFlux(test_audio, windowSize, hopSize);
     elseif(strcmp(method_str, 'peak_amp'))
         nvt = myPeakEnv(test_audio, windowSize, hopSize);
     elseif(strcmp(method_str, 'wpd'))
         nvt = myWPD(test_audio, windowSize, hopSize);
     else
         error(['Novelty Function (' method_str ') not supported.']);
     end
     
     % Get onsets.
     onset_time_secs = myOnsetDetection(nvt, test_fs, windowSize, hopSize);
     
     % Evaluate.
     cur_truths = dlmread(cur_truth_path);
     [file_p, file_r, file_f] = evaluateOnsets(onset_time_secs, cur_truths, deltaTime);
     precision = precision + file_p;
     recall = recall + file_r;
     f_measure = f_measure + file_f;
     % disp([num2str(file_p) ',' num2str(file_r) ',' num2str(file_f)]);
  end
  
  precision = precision / num_test_files;
  recall = recall / num_test_files;
  f_measure = f_measure / num_test_files;
  
end

