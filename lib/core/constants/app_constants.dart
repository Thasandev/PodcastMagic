class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Kaan';
  static const String appTagline = 'Your commute, your classroom';
  static const String appVersion = '1.0.0';

  // Supabase (set from env)
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // OpenAI
  static const String openaiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );

  // Audio
  static const int defaultSnipDurationSec = 30;
  static const int snipBufferSec = 10;
  static const double minPlaybackSpeed = 0.5;
  static const double maxPlaybackSpeed = 3.0;
  static const double defaultPlaybackSpeed = 1.0;
  static const List<double> playbackSpeeds = [
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    1.75,
    2.0,
    2.5,
    3.0,
  ];

  // Commute
  static const int minCommuteDuration = 15;
  static const int maxCommuteDuration = 120;
  static const int defaultCommuteDuration = 45;

  // Gamification
  static const int dailyLoginCoins = 10;
  static const int streakDayCoins = 20;
  static const int reflectionShareCoins = 15;
  static const int referralCoins = 100;
  static const int maxReflectionDurationSec = 60;

  // Pahalwan rankings (streak tiers)
  static const Map<String, int> pahalwanRanks = {
    'Chotu': 0,
    'Shishya': 7,
    'Pehilwan': 30,
    'Ustaad': 90,
    'Maharathi': 180,
    'Legend': 365,
  };

  // Languages
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिंदी'},
    {'code': 'hinglish', 'name': 'Hinglish', 'nativeName': 'Hinglish'},
    {'code': 'ta', 'name': 'Tamil', 'nativeName': 'தமிழ்'},
    {'code': 'te', 'name': 'Telugu', 'nativeName': 'తెలుగు'},
    {'code': 'bn', 'name': 'Bengali', 'nativeName': 'বাংলা'},
    {'code': 'mr', 'name': 'Marathi', 'nativeName': 'मराठी'},
    {'code': 'gu', 'name': 'Gujarati', 'nativeName': 'ગુજરાતી'},
    {'code': 'pa', 'name': 'Punjabi', 'nativeName': 'ਪੰਜਾਬੀ'},
    {'code': 'ml', 'name': 'Malayalam', 'nativeName': 'മലയാളം'},
    {'code': 'kn', 'name': 'Kannada', 'nativeName': 'ಕನ್ನಡ'},
  ];

  // Interest categories
  static const List<Map<String, dynamic>> interestCategories = [
    {
      'id': 'technology',
      'name': 'Technology',
      'icon': '💻',
      'color': 0xFF42A5F5,
    },
    {'id': 'business', 'name': 'Business', 'icon': '💼', 'color': 0xFF66BB6A},
    {'id': 'science', 'name': 'Science', 'icon': '🔬', 'color': 0xFFAB47BC},
    {
      'id': 'health',
      'name': 'Health & Fitness',
      'icon': '💪',
      'color': 0xFFEF5350,
    },
    {'id': 'comedy', 'name': 'Comedy', 'icon': '😂', 'color': 0xFFFFA726},
    {'id': 'education', 'name': 'Education', 'icon': '📚', 'color': 0xFF5C6BC0},
    {'id': 'news', 'name': 'Daily News', 'icon': '📰', 'color': 0xFF26A69A},
    {'id': 'cricket', 'name': 'Cricket', 'icon': '🏏', 'color': 0xFF8D6E63},
    {
      'id': 'motivation',
      'name': 'Motivation',
      'icon': '🔥',
      'color': 0xFFFF7043,
    },
    {'id': 'history', 'name': 'History', 'icon': '🏛️', 'color': 0xFF78909C},
    {
      'id': 'spirituality',
      'name': 'Spirituality',
      'icon': '🕉️',
      'color': 0xFFFFCA28,
    },
    {'id': 'finance', 'name': 'Finance', 'icon': '💰', 'color': 0xFF4CAF50},
    {
      'id': 'movies',
      'name': 'Movies & Entertainment',
      'icon': '🎬',
      'color': 0xFFE91E63,
    },
    {'id': 'politics', 'name': 'Politics', 'icon': '🏛️', 'color': 0xFF607D8B},
    {'id': 'startups', 'name': 'Startups', 'icon': '🚀', 'color': 0xFF29B6F6},
    {
      'id': 'books',
      'name': 'Book Summaries',
      'icon': '📖',
      'color': 0xFF9C27B0,
    },
  ];

  // Animations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animVerySlow = Duration(milliseconds: 800);

  // API timeouts
  static const Duration apiTimeout = Duration(seconds: 15);
  static const Duration aiTimeout = Duration(seconds: 30);
}
