#!/usr/bin/python3

import gopigo3
import easygopigo3 as easy
import time

easygpg = easy.EasyGoPiGo3()

easygpg.open_eyes()
time.sleep(2)
easygpg.close_eyes()
easygpg.set_eye_color((0,255,0))
easygpg.open_eyes()
time.sleep(2)
easygpg.close_eyes()
easygpg.set_eye_color((255,0,0))
easygpg.open_eyes()
time.sleep(2)
easygpg.close_eyes()
#time.sleep(5)
#easygpg.open_left_eye()
#time.sleep(2)
#easygpg.close_left_eye()


# set_left_eye_color(color)
# set_left_right_color(color)
# set_eye_color(color)

