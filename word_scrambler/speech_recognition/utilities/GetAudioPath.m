function path = GetAudioPath(word, dataset)
  first_letter = word(1);
  path = ['../dataset/manual/audio/' dataset '/' first_letter '/'];
end

