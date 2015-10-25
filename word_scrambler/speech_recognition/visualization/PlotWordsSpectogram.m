function PlotWordsSpectogram(words)
  BLOCK_SIZE = 1024;
  HOP_SIZE = 512;
  FS = 22050;
  
  num_words = size(words, 1);
  datasets = {'google'; 'lingoes'; 'merriam_webster'};
  num_datasets = size(datasets, 1);

  for word_idx = 1:num_words
    current_word = words{word_idx};
    figure();
    axes = [];
    for dataset_idx = 1:num_datasets
      cur_dataset = datasets{dataset_idx};
      cur_ax = subplot(num_datasets, 1, dataset_idx);
      axes = [axes; cur_ax];
      
      % Load the word audio.
      [audio, fs] = LoadWordAudio(current_word, cur_dataset);
      
      % Same fs.
      normalized_audio = resample(audio, FS, fs);
      % Multichannel to mono.
      normalized_audio = sum(normalized_audio, 2);
      % Peak level normalization.
      normalized_audio = normalized_audio ./ max(abs(normalized_audio));
      
      % Make the spectogram happen.
      blocked_audio = BlockSignal(normalized_audio, BLOCK_SIZE, HOP_SIZE).';
      spectogram = abs(fft(blocked_audio));
      spectogram = flipud(spectogram(1:floor(BLOCK_SIZE / 2), :));
      clims = [0 5];
      imagesc(spectogram, clims);
      colorbar
      title(['Word: ' current_word ', Database: ' cur_dataset]);
    end
    linkaxes(axes, 'xy');
  end
end

