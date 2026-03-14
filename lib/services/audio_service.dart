import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'audio_handler.dart';
import '../core/models/models.dart';

final audioHandlerProvider = Provider<KaanAudioHandler>((ref) {
  throw UnimplementedError(); // Initialized in main
});

class AudioPlaybackService {
  final KaanAudioHandler _handler;

  AudioPlaybackService(this._handler);

  Stream<bool> get playingStream => _handler.playbackState.map((state) => state.playing);
  Stream<Duration> get positionStream => _handler.player.positionStream; 
  Stream<audio_pkg.PlaybackState> get stateStream => _handler.playbackState;
  Stream<audio_pkg.PlaybackState> get playbackStateStream => _handler.playbackState;
  Stream<audio_pkg.MediaItem?> get mediaItemStream => _handler.mediaItem;
  
  KaanAudioHandler get handler => _handler;

  Future<void> playEpisode(Episode episode) async {
    await _handler.playFromUri(
      Uri.parse(episode.audioUrl),
      {
        'title': episode.title,
        'podcast_name': episode.podcastName,
        'image_url': episode.podcastImageUrl,
        'duration': episode.durationSeconds,
      },
    );
  }

  Future<void> play() => _handler.play();
  Future<void> pause() => _handler.pause();
  Future<void> seek(Duration position) => _handler.seek(position);
  Future<void> setSpeed(double speed) => _handler.player.setSpeed(speed);
  Future<void> rewind() => _handler.seek(_handler.player.position - const Duration(seconds: 10));
  Future<void> fastForward() => _handler.seek(_handler.player.position + const Duration(seconds: 30));
}

final audioServiceProvider = Provider<AudioPlaybackService>((ref) {
  final handler = ref.watch(audioHandlerProvider);
  return AudioPlaybackService(handler);
});
