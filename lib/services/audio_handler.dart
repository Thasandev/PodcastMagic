import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class KaanAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  KaanAudioHandler() {
    // Broadcast state changes
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> playFromUri(Uri uri, [Map<String, dynamic>? extras]) async {
    final mediaItem = MediaItem(
      id: uri.toString(),
      album: extras?['podcast_name'] ?? 'Kaan Podcast',
      title: extras?['title'] ?? 'Podcast Episode',
      artUri: extras?['image_url'] != null ? Uri.parse(extras!['image_url']) : null,
      duration: extras?['duration'] != null ? Duration(seconds: extras!['duration']) : null,
    );
    this.mediaItem.add(mediaItem);
    await _player.setAudioSource(AudioSource.uri(uri));
    return play();
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  AudioPlayer get player => _player;
}
