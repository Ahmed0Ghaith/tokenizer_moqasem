/// Configuration classes for the tokenizer
library;

import 'dart:convert';

/// Enum for different tokenization strategies
enum TokenizationType {
  /// Word-based tokenization
  word,

  /// Sentence-based tokenization
  sentence,

  /// Character-based tokenization
  character,

  /// Whitespace-based tokenization
  whitespace,

  /// N-gram tokenization
  ngram,

  /// Custom regex pattern tokenization
  custom,
}

/// Enum for language detection
enum Language {
  /// English language
  english,

  /// Arabic language
  arabic,

  /// Mixed languages
  mixed,

  /// Unknown language
  unknown,
}

/// Configuration class for tokenizer
///
/// Provides extensive configuration options for customizing
/// tokenization behavior, text processing, and similarity matching.
class TokenizerConfig {
  /// The tokenization strategy to use
  final TokenizationType type;

  /// Convert text to lowercase
  final bool toLowerCase;

  /// Remove punctuation from tokens
  final bool removePunctuation;

  /// Remove stop words from tokens
  final bool removeStopWords;

  /// Custom set of stop words (if empty, uses default)
  final Set<String> stopWords;

  /// Size of n-grams when using ngram tokenization
  final int ngramSize;

  /// Custom regex pattern for custom tokenization
  final RegExp? customPattern;

  /// Normalize Arabic text (diacritics, alef variations, etc.)
  final bool normalizeArabic;

  /// Use fuzzy matching for similarity calculations
  final bool useFuzzyMatching;

  /// Minimum similarity threshold for fuzzy matching (0.0 - 1.0)
  final double fuzzyThreshold;

  /// Enable caching for improved performance
  final bool enableCaching;

  /// Cache size limit (number of entries)
  final int cacheSize;

  /// Use phonetic matching for Arabic
  final bool usePhoneticMatching;

  /// Enable stemming/root extraction
  final bool enableStemming;

  /// Creates a new tokenizer configuration
  const TokenizerConfig({
    this.type = TokenizationType.word,
    this.toLowerCase = false,
    this.removePunctuation = false,
    this.removeStopWords = false,
    this.stopWords = const {},
    this.ngramSize = 2,
    this.customPattern,
    this.normalizeArabic = true,
    this.useFuzzyMatching = true,
    this.fuzzyThreshold = 0.7,
    this.enableCaching = true,
    this.cacheSize = 1000,
    this.usePhoneticMatching = false,
    this.enableStemming = false,
  }) : assert(fuzzyThreshold >= 0.0 && fuzzyThreshold <= 1.0),
       assert(ngramSize > 0),
       assert(cacheSize > 0);

  /// Creates a configuration optimized for Arabic text
  factory TokenizerConfig.arabicOptimized() {
    return const TokenizerConfig(
      normalizeArabic: true,
      usePhoneticMatching: true,
      useFuzzyMatching: true,
      fuzzyThreshold: 0.75,
      enableStemming: true,
    );
  }

  /// Creates a configuration optimized for English text
  factory TokenizerConfig.englishOptimized() {
    return const TokenizerConfig(
      toLowerCase: true,
      removePunctuation: true,
      removeStopWords: true,
      normalizeArabic: false,
      usePhoneticMatching: false,
    );
  }

  /// Creates a configuration for strict matching (no fuzzy)
  factory TokenizerConfig.strictMatching() {
    return const TokenizerConfig(
      useFuzzyMatching: false,
      usePhoneticMatching: false,
      normalizeArabic: false,
    );
  }

  /// Copy configuration with modifications
  TokenizerConfig copyWith({
    TokenizationType? type,
    bool? toLowerCase,
    bool? removePunctuation,
    bool? removeStopWords,
    Set<String>? stopWords,
    int? ngramSize,
    RegExp? customPattern,
    bool? normalizeArabic,
    bool? useFuzzyMatching,
    double? fuzzyThreshold,
    bool? enableCaching,
    int? cacheSize,
    bool? usePhoneticMatching,
    bool? enableStemming,
  }) {
    return TokenizerConfig(
      type: type ?? this.type,
      toLowerCase: toLowerCase ?? this.toLowerCase,
      removePunctuation: removePunctuation ?? this.removePunctuation,
      removeStopWords: removeStopWords ?? this.removeStopWords,
      stopWords: stopWords ?? this.stopWords,
      ngramSize: ngramSize ?? this.ngramSize,
      customPattern: customPattern ?? this.customPattern,
      normalizeArabic: normalizeArabic ?? this.normalizeArabic,
      useFuzzyMatching: useFuzzyMatching ?? this.useFuzzyMatching,
      fuzzyThreshold: fuzzyThreshold ?? this.fuzzyThreshold,
      enableCaching: enableCaching ?? this.enableCaching,
      cacheSize: cacheSize ?? this.cacheSize,
      usePhoneticMatching: usePhoneticMatching ?? this.usePhoneticMatching,
      enableStemming: enableStemming ?? this.enableStemming,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'toLowerCase': toLowerCase,
      'removePunctuation': removePunctuation,
      'removeStopWords': removeStopWords,
      'stopWords': stopWords.toList(),
      'ngramSize': ngramSize,
      'customPattern': customPattern?.pattern,
      'normalizeArabic': normalizeArabic,
      'useFuzzyMatching': useFuzzyMatching,
      'fuzzyThreshold': fuzzyThreshold,
      'enableCaching': enableCaching,
      'cacheSize': cacheSize,
      'usePhoneticMatching': usePhoneticMatching,
      'enableStemming': enableStemming,
    };
  }

  /// Create from JSON
  factory TokenizerConfig.fromJson(Map<String, dynamic> json) {
    return TokenizerConfig(
      type: TokenizationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TokenizationType.word,
      ),
      toLowerCase: json['toLowerCase'] as bool? ?? false,
      removePunctuation: json['removePunctuation'] as bool? ?? false,
      removeStopWords: json['removeStopWords'] as bool? ?? false,
      stopWords:
          (json['stopWords'] as List?)?.map((e) => e.toString()).toSet() ??
          const {},
      ngramSize: json['ngramSize'] as int? ?? 2,
      customPattern: (json['customPattern'] as String?)?.isNotEmpty == true
          ? RegExp(json['customPattern'] as String)
          : null,
      normalizeArabic: json['normalizeArabic'] as bool? ?? true,
      useFuzzyMatching: json['useFuzzyMatching'] as bool? ?? true,
      fuzzyThreshold: (json['fuzzyThreshold'] as num?)?.toDouble() ?? 0.7,
      enableCaching: json['enableCaching'] as bool? ?? true,
      cacheSize: json['cacheSize'] as int? ?? 1000,
      usePhoneticMatching: json['usePhoneticMatching'] as bool? ?? false,
      enableStemming: json['enableStemming'] as bool? ?? false,
    );
  }

  /// Convert to JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Create from JSON string
  factory TokenizerConfig.fromJsonString(String jsonString) {
    return TokenizerConfig.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  @override
  String toString() {
    return 'TokenizerConfig(type: $type, fuzzy: $useFuzzyMatching, threshold: $fuzzyThreshold)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenizerConfig &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          toLowerCase == other.toLowerCase &&
          removePunctuation == other.removePunctuation &&
          removeStopWords == other.removeStopWords &&
          stopWords.length == other.stopWords.length &&
          stopWords.containsAll(other.stopWords) &&
          ngramSize == other.ngramSize &&
          customPattern?.pattern == other.customPattern?.pattern &&
          normalizeArabic == other.normalizeArabic &&
          useFuzzyMatching == other.useFuzzyMatching &&
          fuzzyThreshold == other.fuzzyThreshold &&
          enableCaching == other.enableCaching &&
          cacheSize == other.cacheSize &&
          usePhoneticMatching == other.usePhoneticMatching &&
          enableStemming == other.enableStemming;

  @override
  int get hashCode =>
      type.hashCode ^
      toLowerCase.hashCode ^
      removePunctuation.hashCode ^
      removeStopWords.hashCode ^
      stopWords.hashCode ^
      ngramSize.hashCode ^
      (customPattern?.pattern.hashCode ?? 0) ^
      normalizeArabic.hashCode ^
      useFuzzyMatching.hashCode ^
      fuzzyThreshold.hashCode ^
      enableCaching.hashCode ^
      cacheSize.hashCode ^
      usePhoneticMatching.hashCode ^
      enableStemming.hashCode;
}
