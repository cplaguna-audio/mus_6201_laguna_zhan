function [audio, fs] = LoadWordAudio(word, dataset)
  first_letter = word(1);
  word_path = GetAudioPath(word, dataset);
  word_mp3_path = [word_path word '.mp3'];
  word_wav_path = [word_path word '.wav'];

  if exist(word_mp3_path, 'file') == 2
    [audio, fs] = audioread(word_mp3_path);
  elseif (exist(word_wav_path, 'file') == 2)
    [audio, fs] = audioread(word_wav_path);
  else
    error(['Could not find word: ' word ' in dataset: ' ...
           dataset '.']);
  end
end

