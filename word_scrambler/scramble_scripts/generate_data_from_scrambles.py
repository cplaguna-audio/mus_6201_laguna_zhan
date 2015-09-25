# Based on scrambles specified in scrambles.txt, this generates scrambleX.txt
# files in game_engine/scrambles/ and dataset/dataset_words.txt.
#
# scramblesX.txt files list all valid words for a given scramble. The first line
# contains the letters that make up that scramble.
#
# dataset_words.txt is a list of all words in our dataset, which is a union of
# all valid words for each scramble.
import wordutils

scrambles = wordutils.load_scrambles()
dictionary = wordutils.load_dictionary()

idx = 0
words_for_dataset = []
for scramble in scrambles:
  current_valid_words = wordutils.get_all_valid_words(scramble, dictionary)
  
  file_name = '../game_engine/scrambles/scramble' + str(idx) + '.txt'
  scramble_file = open(file_name, 'w')
  
  first_line = ''.join(scramble) + '\n'
  scramble_file.write(first_line)
  for word in current_valid_words:
    scramble_file.write("%s\n" % word)
    words_for_dataset.append(word)

  idx = idx + 1
  scramble_file.close()

# Unique words.
words_for_dataset = set(words_for_dataset)
dataset_word_file_name = '../dataset/dataset_words.txt'
dataset_word_file = open(dataset_word_file_name, 'w')
for word in words_for_dataset:
  dataset_word_file.write("%s\n" % word)
dataset_word_file.close()