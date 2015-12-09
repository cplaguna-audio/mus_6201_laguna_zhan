function word = WhatWordIsthis(audio_path, words) 
  words = words.';
  if(isempty(words))
    word = '';
    return;
  end
  disp(words);
  disp('size of words:');
  disp(size(words));
  load(GetClassifierFilename());
  disp(classifier);
  [audio, fs] = audioread(audio_path);
  
  template = ExtractTemplate({audio}, fs);
  word = ClassifyFromCandidates(classifier, template{1}, words);

end

