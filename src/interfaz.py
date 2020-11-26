from tkinter import Tk, Label, Button, Entry

# Create root object for GUI
root = Tk()

# Create functions to be called upon interaction


def myClick():
    myLabel = Label(root, text=myEntry.get())
    myLabel.pack()


# Create the elements
myEntry = Entry(root, width=50, borderwidth=5)
myButton = Button(root, text="Enter your name", command=myClick)

# Put everything on screen
myEntry.pack()
myButton.pack()

# Start the GUI (loop)
root.mainloop()
