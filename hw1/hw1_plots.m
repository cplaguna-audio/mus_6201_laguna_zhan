DO_PART_1 = false;
DO_PART_2 = false;
DO_PART_3 = true;

fs = 44100;
f1 = 441;
f2 = 882;
duration = 2;

window_size = 4096 * 2;
hop_size = 4096;

t = [1:duration * fs].';
x = zeros(size(t));
x(1:fs) = sin(2 * pi * f1 * t(1:fs) / fs);
x(fs + 1:end) = sin(2 * pi * f2 * t(fs + 1:end) / fs);

% Part 1 %
if(DO_PART_1)
  [acf_f0s, time_in_secs] = myPitchTrack_ACF(x, window_size, hop_size, fs);

  figure();
  plot(time_in_secs, acf_f0s);
  title('Time domain ACF pitch estimates');

  % Plot absolute error.
  num_estimates = size(acf_f0s, 1);
  ground_truths = zeros(num_estimates, 1);
  for estimate_idx = 1:num_estimates
    estimate_time = time_in_secs(estimate_idx);
    if(estimate_time < 1)
      ground_truths(estimate_idx) = 441;
    else
      ground_truths(estimate_idx) = 882;
    end
  end

  absolute_error = CalculateAbsoluteError(acf_f0s, ground_truths);
  figure();
  plot(time_in_secs, absolute_error);
  title('Absolute error over time (ACF)');
end

% Part 2 %
if(DO_PART_2)
  [acf_f0s, time_in_secs] = myPitchTrack_MaxSpec(x, window_size, hop_size, fs);

  figure();
  plot(time_in_secs, acf_f0s);
  title('Spectral Peak pitch estimates');

  % Plot absolute error.
  num_estimates = size(acf_f0s, 1);
  ground_truths = zeros(num_estimates, 1);
  for estimate_idx = 1:num_estimates
    estimate_time = time_in_secs(estimate_idx);
    if(estimate_time < 1)
      ground_truths(estimate_idx) = 441;
    else
      ground_truths(estimate_idx) = 882;
    end
  end

  absolute_error = CalculateAbsoluteError(acf_f0s, ground_truths);
  figure();
  plot(time_in_secs, absolute_error);
  title('Absolute error over time (Spectral Peak)');
end

% Part 3 %
if(DO_PART_3)
  WINDOW_SIZE = 1024;
  HOP_SIZE = 512;
  DATASET_DIR = 'trainData';

  files = dir(DATASET_DIR);
  files = {files.name}.';
  files = files(~strcmp(files, '.') & ...
                            ~strcmp(files, '..') & ...
                            ~strcmp(files, '.DS_Store'));
  audio_files = {};
  annotation_files = {};
  num_annotation_files = 0;
  num_audio_files = 0;
  num_files = size(files, 1);
  for file_idx = 1:num_files
    current_file = files{file_idx};

    if(strcmp(current_file(end-2:end), 'wav'))
      num_audio_files = num_audio_files + 1;
      audio_files{num_audio_files, 1} = current_file;

    elseif(strcmp(current_file(end-2:end), 'txt'))
      num_annotation_files = num_annotation_files + 1;
      annotation_files{num_annotation_files, 1} = current_file;
    end
  end

  if(num_annotation_files ~= num_audio_files)
    error('You should have one annotation file per audio file');
  end

  acf_total_error = 0;
  spect_total_error = 0;
  for test_file_idx = 1:num_audio_files
    audio_file_path = [DATASET_DIR '/' audio_files{test_file_idx}];
    [test_file_audio, fs] = audioread(audio_file_path);
    
    annotation_file_path = [DATASET_DIR '/' ...
                            annotation_files{test_file_idx}];
    annotations = dlmread(annotation_file_path);
    frequency_annotations = annotations(:, 3);
                          
    acf_f0s = myPitchTrack_ACF(test_file_audio, WINDOW_SIZE, HOP_SIZE, fs);    
    spect_f0s = myPitchTrack_MaxSpec(test_file_audio, WINDOW_SIZE, ...
                                     HOP_SIZE, fs);
      
    acf_rms_error_cents = myEvaluation(acf_f0s, frequency_annotations)
    acf_total_error = acf_total_error + acf_rms_error_cents;
    
    spect_rms_error_cents = myEvaluation(spect_f0s, frequency_annotations);
    spect_total_error = spect_total_error + spect_rms_error_cents;
  end
end

mean_acf_error = acf_total_error / num_audio_files;
mean_spect_error = spect_total_error / num_audio_files;

disp(['Mean ACF RMS Error: ' num2str(mean_acf_error) ' cents.']);
disp(['Mean Spectral Peak RMS Error: ' num2str(mean_spect_error) ...
      ' cents.']);