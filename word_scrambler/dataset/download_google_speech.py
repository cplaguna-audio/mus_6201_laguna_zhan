# Searches google for an mp3 file for each word. If found, downloads the file
# in google/<first_letter>/<word>.mp3. All missing words are stored in 
# missing_words_google.txt.
import urllib
import os

words_file = open('dataset_words.txt')
words = words_file.read().split('\n')

# Create directories
google_dir = 'google'
if not os.path.exists(google_dir):
  os.makedirs(google_dir)

letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
for letter in letters:
  letter_dir = 'google/' + letter
  if not os.path.exists(letter_dir):
    os.makedirs(letter_dir)

# Download each word file from google.
failed_words = []
for word in words:
  if not word:
    continue
  word_audio_file = urllib.URLopener()
  url = 'https://ssl.gstatic.com/dictionary/static/sounds/de/0/' + word + '.mp3'
  file_path = 'google/' + word[0] + '/' + word + ".mp3"
  try:
    word_audio_file.retrieve(url, file_path)
  except IOError:
  	print word
  	failed_words.append(word)

failed_words_file_name = 'missing_words_google.txt'
failed_words_file = open(failed_words_file_name, 'w')
for word in failed_words:
	failed_words_file.write("%s\n" % word)
