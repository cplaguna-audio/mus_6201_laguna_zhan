function templates = ExtractTemplate(audio_examples, sample_rates)
  FEATURES = 'spectral';  % 'fft-bank', 'mfcc', 'spectral', 'good'
  FS = 22050;
  BLOCK_SIZE = 1024;
  HOP_SIZE = 256;
  NUM_BANDS = 16;
  NUM_MFCCS = 20;
  templates = {};
  
  num_examples = size(audio_examples, 1);
  example_templates = cell(num_examples, 1);
  for example_idx = 1:num_examples
    current_audio = audio_examples{example_idx, 1};
    current_fs = sample_rates(example_idx, 1);
    
    % Normalize audio.
    % Same fs.
    normalized_audio = resample(current_audio, FS, current_fs);
    
    % Multichannel to mono.
    normalized_audio = sum(normalized_audio, 2);
    % Peak level normalization.
    normalized_audio = normalized_audio ./ max(abs(normalized_audio));

    % Crop out silence.
    [start, stop] = VocalActivityEndpoints(normalized_audio);

    cropped_audio = normalized_audio(start:stop, 1);

    % Extract features.
    current_template = {};
    if(strcmp(FEATURES, 'fft-bank'))
      current_template = ExtractFFTBank(cropped_audio, BLOCK_SIZE, ...
                                        HOP_SIZE, NUM_BANDS);
    elseif(strcmp(FEATURES, 'mfcc'))
      current_template = ExtractMFCCs(cropped_audio, BLOCK_SIZE, HOP_SIZE, current_fs, NUM_MFCCS);
    elseif(strcmp(FEATURES, 'spectral'))
      current_template = ExtractSpectralFeatures(cropped_audio, BLOCK_SIZE, HOP_SIZE);
    elseif(strcmp(FEATURES, 'good'))
      current_template = ExtractGoodFeatures(cropped_audio, BLOCK_SIZE, HOP_SIZE, current_fs);
    else
      error([FEATURES 'is not a valid FEATURES option.']);
    end
    
    example_templates{example_idx, 1} = current_template;
  end
  
  % Use multiple templates
  templates = example_templates;
  
  % OR, 
  % Aggregate multiple templates into single template.
  % templates{1, 1} = example_templates{1, 1};
end
