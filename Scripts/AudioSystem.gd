extends Node;

const MAX_SOUND_EFFECTS := 20;
var MusicPlayer : AudioStreamPlayer3D;

enum SongCatalog {
	NIL,
	DAWN,
	DAY,
	DUSK,
	NIGHT,
	MAX
}
var Songs = [
	load(""),
	load("res://Assets/music/GameJamDawn_FINISHED.wav"),
	load(""),
	preload("res://Assets/music/GameJam_Dusk_FINISHED.wav"),
	preload("res://Assets/music/GameJamNight_FINISHED.wav"),
];
enum SoundEffectCatalog {
	NIL,
	AH,
	PLING,
	PWOSH,
	MM,
	MAX
}
var Dead: bool = false;
var SoundEffects = [
	preload("res://Assets/sounds/AH.wav"),
	preload("res://Assets/sounds/AH.wav"),
	preload("res://Assets/sounds/Pling.wav"),
	preload("res://Assets/sounds/Pwosh.wav"),
	preload("res://Assets/sounds/MM.wav"),
];
var AudioStreams = [];
var current_index = 3;
var override_index = 1;
var sounds_muffled := false;
func restart() -> void:
	Dead = false;
	for i in range(get_child_count()):
		remove_child(get_children()[0]);
	AudioStreams = [];
	AudioStreams.resize(MAX_SOUND_EFFECTS);
	MusicPlayer = AudioStreamPlayer3D.new();
	MusicPlayer.stream = Songs[current_index];
	MusicPlayer.finished.connect(switch_song);
	MusicPlayer.bus = "Music";
	MusicPlayer.name = "MusicPlayer";
	add_child(MusicPlayer);
	AudioStreams[0] = MusicPlayer;
	MusicPlayer.play();

	
	var sound_effects = Node.new();
	sound_effects.name = "SoundEffects";
	add_child(sound_effects);

func _physics_process(_delta: float) -> void:
	if sounds_muffled:
		for i in range(len(AudioStreams)):
			if AudioStreams[i] != null && AudioStreams[i].max_db > -2.0:
				AudioStreams[i].max_db -= 0.05;
	if !sounds_muffled:
		for i in range(len(AudioStreams)):
			if AudioStreams[i] != null && AudioStreams[i].max_db < 3.0:
				AudioStreams[i].max_db += 0.05;
	if Dead:
		for i in range(len(AudioStreams)):
			if AudioStreams[i] != null && AudioStreams[i].max_db > 0.0:
				AudioStreams[i].pitch_scale = move_toward(AudioStreams[i].pitch_scale, 0.01, 0.01);
				
func switch_song():
	print("?");
	current_index += 1;
	if (current_index == SongCatalog.MAX):
		current_index = 1;

	MusicPlayer.stream = Songs[current_index]
	MusicPlayer.play();

func Death():
	print("???");
	Dead = true;

func play_sound_effect(_sound: SoundEffectCatalog = SoundEffectCatalog.NIL, pitchMin = 0.5, pitchMax = 1.5) -> void:
	var player = create_audiostream();
	player.bus = "SoundEffects";
	player.stream = SoundEffects[_sound];
	player.pitch_scale = randf_range(pitchMin,pitchMax);
	$SoundEffects.add_child(player);
	player.play();
	

func muffle_sounds() -> void:
	sounds_muffled = !sounds_muffled;

func create_audiostream() -> AudioStreamPlayer3D:
	for i in range(MAX_SOUND_EFFECTS):
		if AudioStreams[i] == null:
			AudioStreams[i] = AudioStreamPlayer3D.new();
			AudioStreams[i].finished.connect(remove_audiostream.bind(i));
			return AudioStreams[i];
	
	remove_audiostream(override_index)
	AudioStreams[override_index] = AudioStreamPlayer3D.new();
	AudioStreams[override_index].finished.connect(remove_audiostream.bind(override_index));
	var player = AudioStreams[override_index];
	override_index += 1;
	if override_index == MAX_SOUND_EFFECTS:
		override_index = 1;
	return player;



func remove_audiostream(entityId: int) -> void:
	var audioStream = AudioStreams[entityId];

	if audioStream != null:
		$SoundEffects.remove_child(audioStream);
		audioStream.queue_free();
		AudioStreams[entityId] = null;

	return;
