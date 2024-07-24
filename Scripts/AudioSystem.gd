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
	load(""),
	load(""),
	load("res://Assets/music/GameJam_Dusk_FINISHED.wav"),
	load("res://Assets/music/GameJamNight_FINISHED.wav"),
];
enum SoundEffectCatalog {
}
var SoundEffects = [];
var AudioStreams = [];
var current_index = 3
var override_index = 1;

func _ready() -> void:
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

	play_sound_effect(1);

func switch_song():
	current_index += 1;
	if (current_index == SongCatalog.MAX):
		current_index = 1;

	MusicPlayer.stream = Songs[current_index]
	MusicPlayer.play();


func play_sound_effect(sound: SoundEffectCatalog) -> void:
	var player = create_audiostream();
	# player.stream  = SoundEffects[sound];
	player.bus = "SoundEffects";
	$SoundEffects.add_child(player);
	

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
