#!/bin/python3

"""
This program will return the navigational data from the current connected drone.
This must be run after connecting to a drone using connectToDrone.sh in lib/

Syntax: sudo ./droneStatus.py
"""

import sys
import os
import time
import subprocess
import importlib
from tkinter import *

numVar = 5 #The number of values we want to track
try:
    import final
except ModuleNotFoundError:
    subprocess.Popen(["./.droneStatus.sh", "{}".format(numVar)])
    time.sleep(.5)
    import final

stop = False
    
def close():
    root.destroy()

root = Tk()
root.title('Status')
root.geometry("150x150")

string = StringVar()
l = Label(root, textvariable = string, justify=LEFT)
l.pack()
btn = Button(root, text="Exit", command=close)
btn.pack()

subprocess.Popen(["node" , "navdata.js", "&"])
subprocess.Popen(["./.droneStatus.sh", "{}".format(numVar)])

while True:
    temp = ""
    importlib.reload(final)
    subprocess.Popen(["./.droneStatus.sh", "{}".format(numVar)])
    temp += "Battery: {}".format(final.Battery)
    temp += "\nAltitude: {}".format(final.Altitude)
    temp += "\nPitch: {}".format(final.Pitch)
    temp += "\nRoll: {}".format(final.Roll)
    temp += "\nYaw: {}".format(final.Yaw)
    string.set(temp)
    root.update()
    time.sleep(.25)
