from Tkinter import *
from math import floor
import time
from threading import Timer
from random import randint

class WordScrambler:

	##### Instance Variables for Widgets #####
	# root
	# words_frame  # The frame where we display the words the user guessed.
	# scramble_label # The label where we display the letters in the scramble.
	# text_entry # Where the user enters words.
	# time_remaining_label # Where we display the time remaining.
	# score_label # Where we display the user's score.
  # game_control_button # Button where the user stops and starts the game.


  def __init__(self):
    # Create the interface.
    self.game_width = 400;
    debug = False
    
    self.TOTAL_NUMBER_SCRAMBLES = 15
    self.SCRAMBLE_PATH = "./scrambles/"
    self.scramble_id = -1

    self.root = Tk()
    Grid.columnconfigure(self.root, 0, weight=1)
    Grid.rowconfigure(self.root, 3, weight=1)

    title_frame = Frame(self.root, height = 50)
    title_frame.grid(row = 0, sticky = E+W)
    title_label = Label(title_frame, text = "Word Scrambler").pack(expand = 1)

    user_prompt_frame = Frame(self.root, height = 50)
    user_prompt_frame.grid(row = 1, sticky = E+W)
    self.user_prompt_label = Label(user_prompt_frame)
    self.user_prompt_label.pack(expand = 1)

    scramble_frame = Frame(self.root, height = 50)
    scramble_frame.grid(row = 2, sticky = E+W)
    self.scramble_label = Label(scramble_frame)
    self.scramble_label.pack(expand = 1)

    self.words_frame = Frame(self.root, height = 300)
    self.words_frame.grid(row = 3, sticky = E+W+N+S)
    Grid.columnconfigure(self.words_frame, 0, weight=1)
    self.words_frame.pack_propagate(0)
    self.words_container = Frame(self.words_frame)
    self.words_container.pack()
 
    self.game_control_frame = Frame(self.root, height = 50)
    self.game_control_frame.grid(row = 4, sticky = E+W)
    Grid.columnconfigure(self.game_control_frame, 0, weight=1)

    self.text_entry = Entry(self.game_control_frame)
    self.text_entry.insert(0, "Enter Words Here")
    self.text_entry.config(state = DISABLED)
    self.text_entry.grid(row = 0, column = 0, sticky = W)
    self.text_entry_button = Button(self.game_control_frame, text = "enter", command = self.check_word)
    self.text_entry_button.grid(row = 1, column = 0, sticky = W)
    self.score_label = Label(self.game_control_frame, text = "score")
    self.score_label.grid(row = 0, column = 1, sticky = E)

    self.time_remaining_label = Label(self.game_control_frame, text = "time remaining")
    self.time_remaining_label.grid(row = 1, column = 1, sticky = E)

    self.menu_frame = Frame(self.root, height = 50)
    self.menu_frame.grid(row = 5, sticky = E+W)

    self.begin_game_button = Button(self.menu_frame, text = "Begin Game", command = self.begin_game_pressed)
    self.begin_game_button.grid(row = 0, column = 0)
    self.end_game_button = Button(self.menu_frame, text = "End Game", command = self.end_game_pressed)
    self.end_game_button.grid(row = 0, column = 1)

    if(debug):
      title_frame.config(background = "green")
      scramble_frame.config(background = 'purple')
      self.words_frame.config(background = 'blue')
      self.game_control_frame.config(background = 'red')
      self.menu_frame.config(background = 'orange')
      user_prompt_frame.config(background = 'brown')

    self.num_words_displayed = -1;
    self.score = -1
    self.time_remaining = -1
    self.scramble_letters = ['a', 'b', 'y', 'i', 'n', 'g']
    self.scramble_words = ['rithesh', 'chris', 'ying', 'stupid', 'unsmart']
    self.remaining_words = []
    self.prompt_text = ""
    self.max_num_rows = 10
    self.game_time = 60
    self.playing_game = False
    self.root.mainloop()


  def set_scramble(self):
    next_id = randint(0, self.TOTAL_NUMBER_SCRAMBLES)
    while(next_id == self.scramble_id):
      next_id = randint(0, self.TOTAL_NUMBER_SCRAMBLES)
    self.scramble_id = next_id

    scramble_file_name = self.SCRAMBLE_PATH + 'scramble' + str(self.scramble_id) + '.txt'
    scramble_file = open(scramble_file_name)
    scramble_lines = scramble_file.read().split('\n')
    self.scramble_letters = list(scramble_lines[0])
    self.scramble_words = scramble_lines[1:]
    self.scramble_words =[a for a in self.scramble_words if a]
    print self.scramble_letters
    print self.scramble_words

  # The game is finished, so remove display and reset state.
  def flush_game(self):
    self.num_words_displayed = 0
    self.score = -1
    self.time_remaining = -1

    # Kill all the babies (guessed words) in the words container.
    for baby in self.words_container.winfo_children():
      baby.destroy()

  # Look up new scramble and begin the new game.
  def start_game(self):
    self.playing_game = True
    self.set_scramble()
    self.score = 0
    self.time_remaining = self.game_time
    self.prompt_text = "Find Words Out Of The Letters Below"
    self.remaining_words = list(self.scramble_words)
    self.num_words_displayed = 0;
    self.text_entry.config(state = NORMAL)

    self.update_display()
    Timer(1, self.advance_time).start()

  def begin_game_pressed(self):
    if(not self.check_if_playing_game()):
      self.flush_game()
      self.start_game()

  def end_game_pressed(self):
    if(self.check_if_playing_game()):
      self.game_over()
      self.update_display()

  def game_over(self):
    if(self.playing_game):
      self.playing_game = False
      self.time_remaining = 0
      self.prompt_text = "Game Over"
      self.text_entry.config(state = DISABLED)
      for word in self.remaining_words:
        self.add_word_to_game_label(word, 'red')
      self.update_display()

  def update_display(self):
    scramble_string = ""
    for letter in self.scramble_letters:
      scramble_string = scramble_string + letter + " "
    self.scramble_label.config(text = scramble_string)
    self.score_label.config(text = "Score: " + str(self.score))
    self.time_remaining_label.config(text = "Time remaining: " + str(self.time_remaining))
    self.user_prompt_label.config(text = self.prompt_text);

  def check_word(self):
    if(self.check_if_playing_game()):
      input_word = self.text_entry.get()
      if input_word in self.remaining_words:
        self.remaining_words.remove(input_word)
        self.score = self.score + self.get_word_score(input_word)
        self.prompt_text = "Nice one! Keep on guessing."
        self.add_word_to_game_label(input_word, 'black')
        self.update_display()
      else:
        self.prompt_text = "No way. Keep on guessing."
        self.update_display()
  
  def get_word_score(self, word):
    return len(word);

  def add_word_to_game_label(self, word, color):
    word_score = self.get_word_score(word)
    word_text = word + ": " + str(word_score)
    word_label = Label(self.words_container, text = word_text, fg = color)
    col_idx = int(floor(self.num_words_displayed / self.max_num_rows))
    row_idx = self.num_words_displayed % self.max_num_rows
    word_label.grid(row = row_idx, column = col_idx, sticky = N+S+E+W)
    self.num_words_displayed = self.num_words_displayed + 1

  def advance_time(self):
    print self.time_remaining
    if(not self.check_if_playing_game()):
      self.update_display()
      return
    self.time_remaining = self.time_remaining - 1
    Timer(1, self.advance_time).start()
    self.update_display()

  def check_if_playing_game(self):
    if(not self.playing_game):
      return False
    if(self.time_remaining <= 0):
      self.game_over()
      return False
    if(not self.remaining_words):
      self.game_over()
      return False
    return True

# 	def record_pressed():
#		global recording
#		if(recording_state):
#			recording_state = False
#			print "Recording Stopped!"
#			record_button.config(text = "Start Recording")
#		else:
#			recording_state = True
#			print "Recording Started!"
#			record_button.config(text = "Stop Recording")

game = WordScrambler()
