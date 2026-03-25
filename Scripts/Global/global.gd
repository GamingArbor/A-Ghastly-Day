extends Node

enum States {IDLE, FLOAT, POSSESS, AIR, DEAD, FLOATOVER, DRAG}
enum PossessTypes {STATIC, SLIDE, HOPPING}

# 1=Intro 2=Ending
var Cutscene :int = 0
