function path = GetFeaturePath(word, dataset)
  first_letter = word(1);
  path = ['../dataset/manual/features/' dataset '/' first_letter '/'];
end
