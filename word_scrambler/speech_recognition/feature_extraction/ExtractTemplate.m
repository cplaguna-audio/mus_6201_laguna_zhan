function templates = ExtractTemplate(audio_examples, sample_rates)
  FEATURES = 'fft-bank';  % 'fft-bank', 'mfcc'.
  BLOCK_SIZE = 1024;
  HOP_SIZE = 512;
  NUM_BANDS = 16;
  templates = {};
  
  num_examples = size(audio_examples, 1);
  example_templates = cell(num_examples, 1);
  for example_idx = 1:num_examples
    current_audio = audio_examples{example_idx, 1};
    current_fs = sample_rates(example_idx, 1);
    % Normalize audio.
    % Multichannel to mono.
    normalized_audio = sum(current_audio, 2);
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
      error('mfccs are not yet supported');
    else
      error([FEATURES 'is not a valid FEATURES option.']);
    end
    
    example_templates{example_idx, 1} = current_template;
  end
  
  % Aggregate multiple templates into single template.
  templates{1, 1} = example_templates{1, 1};
end
