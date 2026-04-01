extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func PlayStartingMusic() -> void:
	self.stream = preload("res://Audio/Music/Title + Intro Cutscene.mp3")
	self.play()

func ContinueStartingMusic() -> void:
	self.play(self.get_playback_position())

func StopStartingMusic() -> void:
	self.stop()

func PlayOutsideMusic() -> void:
	self.stream = preload("res://Audio/Music/Ooh Spooky Song.mp3")
func PlayCastleMusic() -> void:
	self.stream = preload("res://Audio/Music/super evil song.mp3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if %Player != null:
		if %Player.room_number >= 11 and self.stream != preload("res://Audio/Music/super evil song.mp3"):
			PlayCastleMusic()
		elif %Player.room_number <= 10 and self.stream != preload("res://Audio/Music/Ooh Spooky Song.mp3"):
			PlayOutsideMusic()
		else:
			pass
	if self.get_parent() is BigRoom and self.playing == false:
		self.play()


func _on_finished() -> void:
	self.play()
