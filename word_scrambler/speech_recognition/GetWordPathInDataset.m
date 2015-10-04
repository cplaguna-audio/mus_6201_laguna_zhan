% Gets the expected path (without file extension) of the word in the
% dataset.
function path = GetWordPathInDataset(word, dataset)
  first_letter = word(1);
  path = ['../dataset/' dataset '/' first_letter '/' word];
end
