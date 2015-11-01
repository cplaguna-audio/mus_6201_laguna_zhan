from Tkinter import *

class WordScrambler:

	##### Instance Variables for Widgets #####
	# root
	# words_frame  # The frame where we display the words the user guessed.
	# scramble_label # The label where we display the letters in the scramble.
	# text_entry # Where the user enters words.
	# time_remaining_label # Where we display the time remaining.
	# score_label # Where we display the user's score.
  # game_control_button # Button where the user stops and starts the game.


  time_remaining = 0
  score = 0
  words_guessed = []
  scramble_words = []
  scramble_letters = []

  def __init__(self):
  	# Create the interface.
  	self.game_width = 400;
 
	self.root = Tk()
 	title_frame = Frame(self.root, width = self.game_width, height = 50, background = "green")
	title_frame.pack()
    	title_label = Label(title_frame, text = "Word Scrambler").pack()

    	scramble_frame = Frame(self.root, width = self.game_width, height = 50, background = "black")
	scramble_frame.pack()
    	self.scramble_label = Label(scramble_frame)

	self.words_frame = Frame(self.root, width = self.game_width, height = 300, background = "blue")
	self.words_frame.pack()
    
    	self.game_control_frame = Frame(self.root, width = self.game_width, height = 50, background = "red")
	self.game_control_frame.pack()
    	self.text_entry = Entry(self.game_control_frame)
	self.text_entry.pack()
    	self.score_label = Label(self.game_control_frame)
	self.score_label.pack()
    	self.time_remaining_label = Label(self.game_control_frame)
	self.time_remaining_label.pack()

    	self.menu_frame = Frame(self.root, width = self.game_width, height = 50, background = "orange")
	self.menu_frame.pack();
    	
	self.begin_game_button = Button(self.menu_frame, text = "Begin Game", command = self.begin_game_pressed)
	self.begin_game_button.pack()
	self.root.mainloop()


  # The game is finished, so remove display and reset state.
  def flush_game(self):
	print "Flush Game"

  # Look up new scramble and begin the new game.
  def start_game(self):
	print "Start Game"

  def begin_game_pressed(self):
  	print "Begin Game Pressed!"

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
