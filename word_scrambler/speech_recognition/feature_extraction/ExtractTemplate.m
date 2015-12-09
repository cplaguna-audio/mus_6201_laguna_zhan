function templates = ExtractTemplate(audio_examples, sample_rates)
  FS = 16000;
  BLOCK_SIZE = 2048;
  HOP_SIZE = 1024;
  NUM_BANDS = 16;
  NUM_MFCCS = 13;
  templates = {};
  
  num_examples = size(audio_examples, 1);
  example_templates = cell(num_examples, 1);
  for example_idx = 1:num_examples
    current_audio = audio_examples{example_idx, 1};
    current_fs = sample_rates(example_idx, 1);
    
    % Normalize audio.
    % Same fs.
    normalized_audio = resample(current_audio, FS, current_fs);
    
    normalized_audio = BandPass(normalized_audio, FS, 200, 7000);
    
    % Crop out silence.
    [start, stop] = VocalActivityEndpoints(normalized_audio);
    if(start == -1)
      example_templates{example_idx, 1} = [];
      continue;
    end
    % Multichannel to mono.
    normalized_audio = sum(normalized_audio, 2);
    % Peak level normalization.
    normalized_audio = normalized_audio ./ max(abs(normalized_audio));

    cropped_audio = normalized_audio(start:stop, 1);

    % Extract features.
    current_template = ExtractAllFeatures(cropped_audio, BLOCK_SIZE, HOP_SIZE, FS);
    
    example_templates{example_idx, 1} = current_template;
  end
  
  % Use multiple templates
  templates = example_templates;
  
  % OR, 
  % Aggregate multiple templates into single template.
  % templates{1, 1} = example_templates{1, 1};
end
