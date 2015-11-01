from Tkinter import *

win = Tk()

frame1 = Frame(win, width = 600, height = 500, background = "red")
frame1.pack()

Label(frame1, text="Name").pack() #.grid(row=0, column=0, sticky=W)
nameVar = StringVar()
name = Entry(frame1, textvariable=nameVar).pack()
# name.grid(row=0, column=1, sticky=W)

Label(frame1, text="Phone").pack() #.grid(row=1, column=0, sticky=W)
phoneVar= StringVar()
phone= Entry(frame1, textvariable=phoneVar).pack()
# phone.grid(row=1, column=1, sticky=W)

frame2 = Frame(win, background = "blue")       # Row of buttons
frame2.pack()
b1 = Button(frame2,text=" Add  ")
b2 = Button(frame2,text="Update")
b3 = Button(frame2,text="Delete")
b4 = Button(frame2,text=" Load ")
b1.pack(side=LEFT); b2.pack(side=LEFT)
b3.pack(side=LEFT); b4.pack(side=LEFT)

win.mainloop()