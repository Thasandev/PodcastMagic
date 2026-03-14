import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kaan/core/constants/app_constants.dart';
import 'package:kaan/services/openai_service.dart';
import 'package:kaan/firebase_options.dart';
import 'package:kaan/app.dart';

import 'package:audio_service/audio_service.dart';
import 'package:kaan/services/audio_handler.dart';
import 'package:kaan/services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  // Initialize Audio Handler
  final audioHandler = await AudioService.init(
    builder: () => KaanAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.kaan.app.channel.audio',
      androidNotificationChannelName: 'Podcast Playback',
      androidNotificationOngoing: true,
    ),
  );

  // Initialize OpenAI Service
  OpenAIService().initialize(AppConstants.openaiApiKey);

  runApp(
    ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(audioHandler as KaanAudioHandler),
      ],
      child: const KaanApp(),
    ),
  );
}
