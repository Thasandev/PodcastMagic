import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/constants/app_constants.dart';

/// OpenAI Service for real AI features
/// User provides their API key via .env or runtime config
class OpenAIService {
  static final OpenAIService _instance = OpenAIService._internal();
  factory OpenAIService() => _instance;
  OpenAIService._internal();

  late final Dio _dio;
  String _apiKey = '';

  void initialize(String apiKey) {
    _apiKey = apiKey;
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openai.com/v1',
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        connectTimeout: AppConstants.aiTimeout,
        receiveTimeout: AppConstants.aiTimeout,
      ),
    );
  }

  bool get isInitialized => _apiKey.isNotEmpty;

  /// Generate AI summary for an episode transcript
  Future<Map<String, dynamic>> generateEpisodeSummary(
    String transcript, {
    String language = 'hinglish',
  }) async {
    if (!isInitialized) return _mockSummary();

    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content':
                  '''You are Kaan AI, a smart audio assistant for Indian commuters. 
Generate a concise summary of the podcast episode transcript.
Response format (JSON):
{
  "summary": "2-3 sentence summary in $language",
  "key_takeaways": ["takeaway 1", "takeaway 2", "takeaway 3", "takeaway 4"],
  "chapters": [{"title": "chapter name", "start_keyword": "first words of section"}],
  "mood": "educational|funny|motivational|news|storytelling"
}
Respond ONLY with valid JSON.''',
            },
            {
              'role': 'user',
              'content': 'Summarize this podcast transcript:\n\n$transcript',
            },
          ],
          'temperature': 0.3,
          'max_tokens': 800,
        },
      );

      final content =
          response.data['choices'][0]['message']['content'] as String;
      return jsonDecode(content);
    } catch (e) {
      return _mockSummary();
    }
  }

  /// Ask Kaan - Q&A about current content
  Future<String> askKaan(
    String question,
    String context, {
    String language = 'hinglish',
  }) async {
    if (!isInitialized) return _mockAnswer(question);

    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content':
                  '''You are Kaan, a friendly AI assistant for Indian commuters. 
Answer questions about podcast content in $language (mix of Hindi and English if hinglish).
Be concise, informative, and conversational. Use Indian references where natural.
Keep answers under 200 words.''',
            },
            {
              'role': 'user',
              'content':
                  'Context from current episode:\n$context\n\nQuestion: $question',
            },
          ],
          'temperature': 0.7,
          'max_tokens': 400,
        },
      );

      return response.data['choices'][0]['message']['content'] as String;
    } catch (e) {
      return _mockAnswer(question);
    }
  }

  /// Generate quiz questions from episode content
  Future<List<Map<String, dynamic>>> generateQuiz(
    String transcript, {
    int numQuestions = 5,
  }) async {
    if (!isInitialized) return _mockQuiz();

    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content':
                  '''Generate $numQuestions quiz questions from this podcast transcript.
Format as JSON array:
[{"question": "...", "options": ["A", "B", "C", "D"], "correct": 0, "explanation": "..."}]
Make questions fun and relevant. Use Hinglish if appropriate.
Respond ONLY with valid JSON array.''',
            },
            {'role': 'user', 'content': transcript},
          ],
          'temperature': 0.5,
          'max_tokens': 1000,
        },
      );

      final content =
          response.data['choices'][0]['message']['content'] as String;
      return List<Map<String, dynamic>>.from(jsonDecode(content));
    } catch (e) {
      return _mockQuiz();
    }
  }

  /// Transcribe audio using Whisper
  Future<String> transcribeAudio(String audioFilePath) async {
    if (!isInitialized)
      return 'Transcription requires OpenAI API key. Please configure it in settings.';

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(audioFilePath),
        'model': 'whisper-1',
        'language': 'hi', // Hindi + English detection
      });

      final response = await _dio.post('/audio/transcriptions', data: formData);
      return response.data['text'] as String;
    } catch (e) {
      return 'Error transcribing audio: $e';
    }
  }

  /// Generate clip title and summary from a saved moment
  Future<Map<String, String>> generateClipMetadata(
    String clipTranscript,
  ) async {
    if (!isInitialized) {
      return {
        'title': 'Saved moment',
        'summary': clipTranscript.length > 100
            ? '${clipTranscript.substring(0, 100)}...'
            : clipTranscript,
      };
    }

    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content':
                  '''Generate a catchy title and brief summary for this podcast clip.
Format as JSON: {"title": "catchy title (max 8 words)", "summary": "1-2 sentence summary"}
Use Hinglish where natural. Add relevant emoji.
Respond ONLY with valid JSON.''',
            },
            {'role': 'user', 'content': clipTranscript},
          ],
          'temperature': 0.7,
          'max_tokens': 200,
        },
      );

      final content =
          response.data['choices'][0]['message']['content'] as String;
      return Map<String, String>.from(jsonDecode(content));
    } catch (e) {
      return {
        'title': 'Saved moment',
        'summary': clipTranscript.length > 100
            ? '${clipTranscript.substring(0, 100)}...'
            : clipTranscript,
      };
    }
  }

  /// Generate embeddings for content recommendation
  Future<List<double>> generateEmbedding(String text) async {
    if (!isInitialized) return [];

    try {
      final response = await _dio.post(
        '/embeddings',
        data: {'model': 'text-embedding-3-small', 'input': text},
      );

      return List<double>.from(response.data['data'][0]['embedding']);
    } catch (e) {
      return [];
    }
  }

  // ============ MOCK RESPONSES ============

  Map<String, dynamic> _mockSummary() => {
    'summary':
        'This episode explores key trends shaping India today. The host breaks down complex topics into digestible insights perfect for your commute.',
    'key_takeaways': [
      'India is at a turning point for technology adoption',
      'Local innovations are gaining global recognition',
      'The talent ecosystem continues to grow rapidly',
      'New opportunities are emerging in tier-2 cities',
    ],
    'chapters': [
      {'title': 'Introduction', 'start_keyword': 'Welcome'},
      {'title': 'Main Discussion', 'start_keyword': 'Let\'s dive'},
      {'title': 'Key Insights', 'start_keyword': 'The important thing'},
      {'title': 'Conclusion', 'start_keyword': 'To wrap up'},
    ],
    'mood': 'educational',
  };

  String _mockAnswer(String question) =>
      'Great question! Based on the current episode, the key point is that innovation in India is accelerating rapidly. '
      'The host discussed how new startups are solving local problems with global-scale solutions. '
      'Agar aur detail chahiye toh episode ke chapter 3 mein deep dive hai! 🎧';

  List<Map<String, dynamic>> _mockQuiz() => [
    {
      'question':
          'According to the episode, what is the biggest challenge discussed?',
      'options': ['Funding', 'Talent gap', 'Infrastructure', 'Regulations'],
      'correct': 1,
      'explanation':
          'The host specifically mentioned the talent gap as the #1 challenge.',
    },
    {
      'question': 'Which sector was highlighted as showing the most growth?',
      'options': ['Agriculture', 'Healthcare', 'Technology', 'Education'],
      'correct': 2,
      'explanation':
          'Technology sector growth was the central theme of the episode.',
    },
    {
      'question': 'What advice was given for beginners?',
      'options': [
        'Start big',
        'Focus on fundamentals',
        'Copy competitors',
        'Hire expensive talent',
      ],
      'correct': 1,
      'explanation':
          'The guest emphasized focusing on fundamentals before scaling.',
    },
  ];
}
