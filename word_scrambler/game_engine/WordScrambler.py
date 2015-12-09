from Tkinter import *
from math import floor
import time
from threading import Timer
from threading import Thread
from random import randint

import matlab.engine
import pyaudio
import wave
import os

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
    # Start the matlab engine first.
    self.matlab = matlab.engine.start_matlab();
    self.matlab.addpath(self.matlab.genpath('/Users/christopherlaguna/Desktop/Georgia_Tech/Fall 2015/MIR/mus_6201_laguna_zhan/word_scrambler/speech_recognition'));

    # Create the interface.
    self.game_width = 400;
    debug = False
    self.use_hard_coded_scramble = True
    self.hard_coded_scramble = 3;
    
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

    self.record_button = Button(self.game_control_frame, text = "Record")
    self.record_button.config(state = DISABLED, command = self.record_button_pressed)
    self.record_button.grid(row = 0, column = 0, sticky = W)
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

    # For audio recording.
    self.CHUNK_SIZE = 1024 
    self.FORMAT = pyaudio.paInt16
    self.CHANNELS = 1 
    self.RATE = 44100
    self.MAX_RECORD_SECONDS = 5
    self.recording = False
    self.finished_writing_audio = False
    self.audio_path = '../speech_recognition/interface/'
    self.audio_name = 'current_word.wav'

    # For matlab
    self.classifier = '';

    # Get the python IO ready.
    self.do_stupid_first_recording();

    self.buffer = []

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

    if(self.use_hard_coded_scramble):
      self.scramble_id = self.hard_coded_scramble

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
    self.record_button.config(state = NORMAL)

    self.classifier = self.matlab.NewScramble(self.scramble_words, nargout=0);
    print self.classifier


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

  def record_button_pressed(self):
    if(self.recording):
      self.recording = False

      while(not self.finished_writing_audio):
        pass
      
      self.check_word()
      self.buffer = []
      self.finished_writing_audio = False

      self.record_button.config(text="Record")

      print "Recording stopped."
    else:
      self.recording = True

      recording_thread = Thread(target = self.record, args = () )
      recording_thread.start()

      self.record_button.config(text="Stop")
      print "Recording started."

  def record(self):
    p = pyaudio.PyAudio()
    stream = p.open(format=self.FORMAT,
                    channels=self.CHANNELS,
                    rate=self.RATE,
                    input=True,
                    frames_per_buffer=self.CHUNK_SIZE) #buffer

    print("* recording")

    for i in range(0, int(self.RATE / self.CHUNK_SIZE * self.MAX_RECORD_SECONDS)):
      if not self.recording:
        break
      data = stream.read(self.CHUNK_SIZE)
      self.buffer.append(data)

    print("* done recording")

    stream.stop_stream()
    stream.close()
    p.terminate()

    wf = wave.open(self.audio_path + self.audio_name, 'wb')
    wf.setnchannels(self.CHANNELS)
    wf.setsampwidth(p.get_sample_size(self.FORMAT))
    wf.setframerate(self.RATE)
    wf.writeframes(b''.join(self.buffer))
    wf.close()

    self.finished_writing_audio = True;

    print("Done writing file.")

  def game_over(self):
    if(self.playing_game):
      self.playing_game = False
      self.time_remaining = 0
      self.prompt_text = "Game Over"
      self.record_button.config(text="Record", state = DISABLED);
      self.recording = False
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
      new_word = self.matlab.WhatWordIsthis(self.audio_name, self.remaining_words)

      print new_word

      if(not new_word):
        self.prompt_text = "Terrible. Just terrible. Keep on guessing."
        self.update_display()
      else:
        self.remaining_words.remove(new_word)
        self.score = self.score + self.get_word_score(new_word)
        self.prompt_text = "Nice one! Keep on guessing."
        self.add_word_to_game_label(new_word, 'black')
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

  def do_stupid_first_recording(self):
    p = pyaudio.PyAudio()
    stream = p.open(format=self.FORMAT,
                    channels=self.CHANNELS,
                    rate=self.RATE,
                    input=True,
                    frames_per_buffer=self.CHUNK_SIZE) #buffer
    frames = []

    for i in range(0, int(100)):
      data = stream.read(self.CHUNK_SIZE)
      frames.append(data)

    stream.stop_stream()
    stream.close()
    p.terminate()

    wf = wave.open(self.audio_path + self.audio_name, 'wb')
    wf.setnchannels(self.CHANNELS)
    wf.setsampwidth(p.get_sample_size(self.FORMAT))
    wf.setframerate(self.RATE)
    wf.writeframes(b''.join(frames))
    wf.close()

    self.matlab.WhatWordIsthis(self.audio_name, []);

game = WordScrambler()
