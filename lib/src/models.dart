/// Model classes for tokenizer results
library;

/// Class to hold word similarity information
class WordSimilarity {
  /// First word in comparison
  final String word1;

  /// Second word in comparison
  final String word2;

  /// Similarity score (0.0 - 1.0)
  final double similarity;

  /// Creates a word similarity result
  const WordSimilarity({
    required this.word1,
    required this.word2,
    required this.similarity,
  });

  /// Get similarity as percentage
  double get percentage => similarity * 100;

  @override
  String toString() {
    return '"$word1" ↔ "$word2": ${percentage.toStringAsFixed(1)}%';
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'word1': word1, 'word2': word2, 'similarity': similarity};
  }

  /// Create from JSON
  factory WordSimilarity.fromJson(Map<String, dynamic> json) {
    return WordSimilarity(
      word1: json['word1'] as String,
      word2: json['word2'] as String,
      similarity: (json['similarity'] is int)
          ? (json['similarity'] as int).toDouble()
          : (json['similarity'] as double),
    );
  }
}

/// Class to hold similarity results
class SimilarityResult {
  /// The compared sentence
  final String sentence;

  /// Similarity percentage (0-100)
  final double percentage;

  /// Rank in comparison results (1-based)
  final int rank;

  /// Word-level matches
  final List<WordSimilarity> wordMatches;

  /// Creates a similarity result
  const SimilarityResult({
    required this.sentence,
    required this.percentage,
    required this.rank,
    this.wordMatches = const [],
  });

  /// Whether this is a strong match (>= 80%)
  bool get isStrongMatch => percentage >= 80.0;

  /// Whether this is a moderate match (>= 60%)
  bool get isModerateMatch => percentage >= 60.0;

  /// Whether this is a weak match (>= 40%)
  bool get isWeakMatch => percentage >= 40.0;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln(
      'Rank $rank: ${percentage.toStringAsFixed(2)}% - "$sentence"',
    );
    if (wordMatches.isNotEmpty) {
      buffer.writeln('  Word Matches:');
      for (final match in wordMatches) {
        buffer.writeln('    $match');
      }
    }
    return buffer.toString();
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'sentence': sentence,
      'percentage': percentage,
      'rank': rank,
      'wordMatches': wordMatches.map((m) => m.toJson()).toList(),
    };
  }

  /// Create from JSON
  factory SimilarityResult.fromJson(Map<String, dynamic> json) {
    return SimilarityResult(
      sentence: json['sentence'] as String,
      percentage: (json['percentage'] is int)
          ? (json['percentage'] as int).toDouble()
          : (json['percentage'] as double),
      rank: (json['rank'] is int) ? json['rank'] as int : int.parse(json['rank'].toString()),
      wordMatches:
          (json['wordMatches'] as List<dynamic>?)
              ?.map((m) => WordSimilarity.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Class to hold text statistics
class TextStatistics {
  /// Total word count
  final int totalWords;

  /// Unique word count
  final int uniqueWords;

  /// Average word length
  final double averageWordLength;

  /// Lexical diversity (unique/total)
  final double lexicalDiversity;

  /// Number of Arabic words
  final int arabicWords;

  /// Number of English words
  final int englishWords;

  /// Number of mixed words
  final int mixedWords;

  /// Token frequency map
  final Map<String, int> frequency;

  /// Creates text statistics
  const TextStatistics({
    required this.totalWords,
    required this.uniqueWords,
    required this.averageWordLength,
    required this.lexicalDiversity,
    required this.arabicWords,
    required this.englishWords,
    required this.mixedWords,
    required this.frequency,
  });

  @override
  String toString() {
    return '''
Text Statistics:
  Total Words: $totalWords
  Unique Words: $uniqueWords
  Average Word Length: ${averageWordLength.toStringAsFixed(2)}
  Lexical Diversity: ${(lexicalDiversity * 100).toStringAsFixed(2)}%
  Arabic Words: $arabicWords
  English Words: $englishWords
  Mixed Words: $mixedWords
''';
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalWords': totalWords,
      'uniqueWords': uniqueWords,
      'averageWordLength': averageWordLength,
      'lexicalDiversity': lexicalDiversity,
      'arabicWords': arabicWords,
      'englishWords': englishWords,
      'mixedWords': mixedWords,
      'frequency': frequency,
    };
  }
}


/// Phonetic match result
class PhoneticMatch {
  /// Original word
  final String word;

  /// Phonetically similar word
  final String match;

  /// Phonetic similarity score
  final double score;

  /// Creates a phonetic match
  const PhoneticMatch({
    required this.word,
    required this.match,
    required this.score,
  });

  @override
  String toString() {
    return '$word ≈ $match (${(score * 100).toStringAsFixed(1)}% phonetic)';
  }
}
