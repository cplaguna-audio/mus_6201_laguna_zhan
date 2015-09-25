def load_dictionary():
  """ Load the dictionary into memory."""
  text_file = open('dictionary.txt')
  words = text_file.read().split('\n')
  return words

def load_scrambles():
  """Load the scrambles into memory."""
  text_file = open('scrambles.txt')
  lines = text_file.read().split('\n')
  scrambles = []
  for line in lines:
    scramble = []
    for character in line:
      if character != ' ':
        scramble.append(character)

    scrambles.append(scramble)

  return scrambles

def get_all_valid_words(letters, english_words):
    """Returns all combinations of |letters| that form valid engish words.

    Arguments:
        letters(list of strings): One entry for each letter in your scramble.
                                   ex. ['b', 'c', 'a', 'x', 't']
        english_words(list of strings): One entry for each word in your 
                                         dictionary of valid words.

    Return Value:
       valid_words(list of strings): One entry for each word.
    """

    # Make everything lower-case for comparison.
    letters = [x.lower() for x in letters]
    english_words = [x.lower() for x in english_words]
    
    # If there were duplicate entries for different capitalizations of different
    # words, remove the dupicates.
    english_words = set(english_words)

    # Get all letter combinations, and check if each one exists in the 
    # dictionary.
    letter_combos = get_all_letter_combinations(letters)
    valid_words = []
    for combo in letter_combos:
        if combo in english_words:
            valid_words.append(combo)
    return valid_words

def get_all_letter_combinations(letters):
  """Return all combinations of letters

  Arguments:
      letters(list of strings): One entry for each letter in your scramble.
                                 ex. ['b', 'c', 'a', 'x', 't']

  Return Value:
      letter_combos(list of strings): One entry for each combination. 

  Example Output:
      letters = ['a' 'b']
      letter_combos = ['a', 'b', 'ab', 'ba']
  """
  letter_combos = []

  # Base cases: No letters -> no combinations, one leter -> one combination.
  if not letters:
    return []
  elif len(letters) == 1:
    return [letters[0]]
  else:
    # Split one-letter vs all-other-letters.
    for idx, current_letter in enumerate(letters):
      other_letters = letters[:idx] + letters[idx + 1:]

      # Find all combinations of length < k.
      smaller_combos = get_all_letter_combinations(other_letters)

      # Prepend the current letter to all the combinations to get all valid
      # combinations of length <= k. Note: This can create duplicates.
      bigger_combos = [current_letter + k for k in smaller_combos]

      # Add all combinations to our working list.
      for bigger_combo in bigger_combos:
        letter_combos.append(bigger_combo)

      for smaller_combo in smaller_combos:
          letter_combos.append(smaller_combo)

  # Remove duplicates and sort.
  letter_combos = sorted(set(letter_combos))
  return letter_combos
