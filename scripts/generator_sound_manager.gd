extends AudioStreamPlayer2D

var sounds := [
'res://assets/sounds/a3.wav', 'res://assets/sounds/b3.wav', 'res://assets/sounds/c3.wav', 
'res://assets/sounds/c4.wav', 'res://assets/sounds/d3.wav', 'res://assets/sounds/e3.wav',
'res://assets/sounds/f3.wav', 'res://assets/sounds/g3.wav']

func play_random_note():
	var audio_file : String = sounds[randi_range(0, sounds.size() - 1)]
	
	if not FileAccess.file_exists(audio_file):
		printerr("Could not find audio file: " + audio_file)
		return
	
	var file = FileAccess.open(audio_file, FileAccess.READ)
	
	var buffer = file.get_buffer(file.get_length())
	file.close()
	
	var audio_stream = AudioStreamWAV.new()
	audio_stream.format = AudioStreamWAV.FORMAT_16_BITS
	audio_stream.data = buffer
	audio_stream.stereo = true
	 
	stream = audio_stream
	play()
