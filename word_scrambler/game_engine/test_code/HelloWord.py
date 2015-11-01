from Tkinter import *

def init_game():
	print "Game Started!"


root = Tk()

w = Label(root, text="Hello Tkinter!")
w.pack()
game_frame = Frame(root, width = 400, height = 600).pack()

record_button = Button(game_frame, text = "Start Recording")
recording_state = False

def record_pressed():
	global recording
	if(recording_state):
		recording_state = False
		print "Recording Stopped!"
		record_button.config(text = "Start Recording")
	else:
		recording_state = True
		print "Recording Started!"
		record_button.config(text = "Stop Recording")


record_button.config(command = record_pressed)
record_button.pack()

begin_button = Button(root, text="Begin", command = init_game).pack()
root.mainloop()
