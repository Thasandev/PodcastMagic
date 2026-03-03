// Data models for the Kaan app

class UserProfile {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? bio;
  final List<String> languages;
  final List<String> interests;
  final int commuteDurationMin;
  final String preferredVoice;
  final int totalListeningMinutes;
  final int currentStreak;
  final int longestStreak;
  final int kaanCoins;
  final String pahalwanRank;
  final int streetCredScore;
  final String? city;
  final String? pinCode;
  final bool onboardingCompleted;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    this.bio,
    this.languages = const ['en'],
    this.interests = const [],
    this.commuteDurationMin = 45,
    this.preferredVoice = 'default',
    this.totalListeningMinutes = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.kaanCoins = 0,
    this.pahalwanRank = 'Chotu',
    this.streetCredScore = 0,
    this.city,
    this.pinCode,
    this.onboardingCompleted = false,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Kaan User',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      languages: List<String>.from(json['languages'] ?? ['en']),
      interests: List<String>.from(json['interests'] ?? []),
      commuteDurationMin: json['commute_duration_min'] as int? ?? 45,
      preferredVoice: json['preferred_voice'] as String? ?? 'default',
      totalListeningMinutes: json['total_listening_minutes'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      kaanCoins: json['kaan_coins'] as int? ?? 0,
      pahalwanRank: json['pahalwan_rank'] as String? ?? 'Chotu',
      streetCredScore: json['street_cred_score'] as int? ?? 0,
      city: json['city'] as String?,
      pinCode: json['pin_code'] as String?,
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'avatar_url': avatarUrl,
        'bio': bio,
        'languages': languages,
        'interests': interests,
        'commute_duration_min': commuteDurationMin,
        'preferred_voice': preferredVoice,
        'total_listening_minutes': totalListeningMinutes,
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'kaan_coins': kaanCoins,
        'pahalwan_rank': pahalwanRank,
        'street_cred_score': streetCredScore,
        'city': city,
        'pin_code': pinCode,
        'onboarding_completed': onboardingCompleted,
        'created_at': createdAt.toIso8601String(),
      };

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? bio,
    List<String>? languages,
    List<String>? interests,
    int? commuteDurationMin,
    String? preferredVoice,
    int? totalListeningMinutes,
    int? currentStreak,
    int? longestStreak,
    int? kaanCoins,
    String? pahalwanRank,
    int? streetCredScore,
    String? city,
    String? pinCode,
    bool? onboardingCompleted,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      languages: languages ?? this.languages,
      interests: interests ?? this.interests,
      commuteDurationMin: commuteDurationMin ?? this.commuteDurationMin,
      preferredVoice: preferredVoice ?? this.preferredVoice,
      totalListeningMinutes: totalListeningMinutes ?? this.totalListeningMinutes,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      kaanCoins: kaanCoins ?? this.kaanCoins,
      pahalwanRank: pahalwanRank ?? this.pahalwanRank,
      streetCredScore: streetCredScore ?? this.streetCredScore,
      city: city ?? this.city,
      pinCode: pinCode ?? this.pinCode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt,
    );
  }
}

class Episode {
  final String id;
  final String title;
  final String description;
  final String podcastName;
  final String? podcastImageUrl;
  final String audioUrl;
  final int durationSeconds;
  final String language;
  final String category;
  final String? aiSummary;
  final List<EpisodeChapter> chapters;
  final String? transcript;
  final int saveCount;
  final DateTime publishedAt;

  const Episode({
    required this.id,
    required this.title,
    required this.description,
    required this.podcastName,
    this.podcastImageUrl,
    required this.audioUrl,
    required this.durationSeconds,
    this.language = 'en',
    required this.category,
    this.aiSummary,
    this.chapters = const [],
    this.transcript,
    this.saveCount = 0,
    required this.publishedAt,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      podcastName: json['podcast_name'] as String,
      podcastImageUrl: json['podcast_image_url'] as String?,
      audioUrl: json['audio_url'] as String,
      durationSeconds: json['duration_seconds'] as int,
      language: json['language'] as String? ?? 'en',
      category: json['category'] as String,
      aiSummary: json['ai_summary'] as String?,
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((c) => EpisodeChapter.fromJson(c))
              .toList() ??
          [],
      transcript: json['transcript'] as String?,
      saveCount: json['save_count'] as int? ?? 0,
      publishedAt: DateTime.parse(json['published_at'] as String),
    );
  }

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return '${hours}h ${mins}m';
    }
    return '${minutes}m ${seconds}s';
  }
}

class EpisodeChapter {
  final String title;
  final int startSeconds;
  final int endSeconds;

  const EpisodeChapter({
    required this.title,
    required this.startSeconds,
    required this.endSeconds,
  });

  factory EpisodeChapter.fromJson(Map<String, dynamic> json) {
    return EpisodeChapter(
      title: json['title'] as String,
      startSeconds: json['start_seconds'] as int,
      endSeconds: json['end_seconds'] as int,
    );
  }
}

class SavedClip {
  final String id;
  final String episodeId;
  final String episodeTitle;
  final String podcastName;
  final String? podcastImageUrl;
  final String audioUrl;
  final int startSeconds;
  final int endSeconds;
  final String? aiTitle;
  final String? aiSummary;
  final String? transcript;
  final DateTime savedAt;

  const SavedClip({
    required this.id,
    required this.episodeId,
    required this.episodeTitle,
    required this.podcastName,
    this.podcastImageUrl,
    required this.audioUrl,
    required this.startSeconds,
    required this.endSeconds,
    this.aiTitle,
    this.aiSummary,
    this.transcript,
    required this.savedAt,
  });

  factory SavedClip.fromJson(Map<String, dynamic> json) {
    return SavedClip(
      id: json['id'] as String,
      episodeId: json['episode_id'] as String,
      episodeTitle: json['episode_title'] as String,
      podcastName: json['podcast_name'] as String,
      podcastImageUrl: json['podcast_image_url'] as String?,
      audioUrl: json['audio_url'] as String,
      startSeconds: json['start_seconds'] as int,
      endSeconds: json['end_seconds'] as int,
      aiTitle: json['ai_title'] as String?,
      aiSummary: json['ai_summary'] as String?,
      transcript: json['transcript'] as String?,
      savedAt: DateTime.parse(json['saved_at'] as String),
    );
  }

  int get durationSeconds => endSeconds - startSeconds;
}

class Reflection {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String? episodeId;
  final String? episodeTitle;
  final String? audioUrl;
  final String transcript;
  final int durationSeconds;
  final String city;
  final int upvotes;
  final int reactionCount;
  final bool isPublic;
  final DateTime createdAt;

  const Reflection({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    this.episodeId,
    this.episodeTitle,
    this.audioUrl,
    required this.transcript,
    required this.durationSeconds,
    this.city = 'Unknown',
    this.upvotes = 0,
    this.reactionCount = 0,
    this.isPublic = true,
    required this.createdAt,
  });

  factory Reflection.fromJson(Map<String, dynamic> json) {
    return Reflection(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userAvatarUrl: json['user_avatar_url'] as String?,
      episodeId: json['episode_id'] as String?,
      episodeTitle: json['episode_title'] as String?,
      audioUrl: json['audio_url'] as String?,
      transcript: json['transcript'] as String? ?? '',
      durationSeconds: json['duration_seconds'] as int? ?? 0,
      city: json['city'] as String? ?? 'Unknown',
      upvotes: json['upvotes'] as int? ?? 0,
      reactionCount: json['reaction_count'] as int? ?? 0,
      isPublic: json['is_public'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class LeaderboardEntry {
  final int rank;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final int listeningMinutes;
  final String pahalwanRank;
  final int streetCredScore;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.listeningMinutes,
    this.pahalwanRank = 'Chotu',
    this.streetCredScore = 0,
    this.isCurrentUser = false,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json, {bool isCurrentUser = false}) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userAvatarUrl: json['user_avatar_url'] as String?,
      listeningMinutes: json['listening_minutes'] as int,
      pahalwanRank: json['pahalwan_rank'] as String? ?? 'Chotu',
      streetCredScore: json['street_cred_score'] as int? ?? 0,
      isCurrentUser: isCurrentUser,
    );
  }

  String get formattedListening {
    if (listeningMinutes >= 60) {
      return '${(listeningMinutes / 60).toStringAsFixed(1)}h';
    }
    return '${listeningMinutes}m';
  }
}

class CoinTransaction {
  final String id;
  final String type; // 'earned' or 'spent'
  final int amount;
  final String reason;
  final DateTime createdAt;

  const CoinTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.reason,
    required this.createdAt,
  });

  factory CoinTransaction.fromJson(Map<String, dynamic> json) {
    return CoinTransaction(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: json['amount'] as int,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class Playlist {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final List<Episode> episodes;
  final int totalDurationSeconds;
  final bool isCollaborative;
  final List<String> memberIds;
  final String createdBy;
  final DateTime createdAt;

  const Playlist({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.episodes = const [],
    this.totalDurationSeconds = 0,
    this.isCollaborative = false,
    this.memberIds = const [],
    required this.createdBy,
    required this.createdAt,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      totalDurationSeconds: json['total_duration_seconds'] as int? ?? 0,
      isCollaborative: json['is_collaborative'] as bool? ?? false,
      memberIds: List<String>.from(json['member_ids'] ?? []),
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class Badge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
  });
}
