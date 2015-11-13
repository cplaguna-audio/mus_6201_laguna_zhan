from Tkinter import *
from threading import Thread
import pyaudio
import wave

####################################
########## For Recording ###########
####################################
class WordRecorder:
  def __init__(self):
    self.CHUNK = 1024 
    self.FORMAT = pyaudio.paInt16 #paInt8
    self.CHANNELS = 1 
    self.RATE = 44100 #sample rate
    self.MAX_RECORD_SECONDS = 5
    self.output_filename = "output.wav"
    self.recording = False

  def set_recording(self, state):
    self.recording = state

  def set_output_filename(self, path):
    self.output_filename = path

  def record(self):
    self.recording = True
    p = pyaudio.PyAudio()
    frames = []

    stream = p.open(format=self.FORMAT,
                    channels=self.CHANNELS,
                    rate=self.RATE,
                    input=True,
                    frames_per_buffer=self.CHUNK) #buffer

    print("* recording")


    for i in range(0, int(self.RATE / self.CHUNK * self.MAX_RECORD_SECONDS)):
      if not self.recording:
        break
      data = stream.read(self.CHUNK)
      frames.append(data)

    print("* done recording")

    stream.stop_stream()
    stream.close()
    p.terminate()

    wf = wave.open(self.output_filename, 'wb')
    wf.setnchannels(self.CHANNELS)
    wf.setsampwidth(p.get_sample_size(self.FORMAT))
    wf.setframerate(self.RATE)
    wf.writeframes(b''.join(frames))
    wf.close()

####################################
############# For GUI ##############
####################################
root = Tk()

w = Label(root, text="Hello Tkinter!")
w.pack()
game_frame = Frame(root, width = 400, height = 600).pack()

recorder = WordRecorder()
record_button = Button(game_frame, text = "Start Recording")
recording_state = False

def record_pressed():
  global recording_state
  global recorder
  if(recording_state):
    recording_state = False
    print "Recording Stopped!"
    record_button.config(text = "Start Recording")
    recorder.set_recording(False)
  else:
    thread = Thread(target = recorder.record, args = () )
    thread.start()
    
    recording_state = True
    print "Recording Started!"
    record_button.config(text = "Stop Recording")

record_button.config(command = record_pressed)
record_button.pack()

root.mainloop()
