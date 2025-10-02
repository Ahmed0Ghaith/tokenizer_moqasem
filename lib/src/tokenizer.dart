/// Main tokenizer implementation with all features
library;

import 'dart:math';
import 'config.dart';
import 'models.dart';
import 'arabic_processor.dart';
import 'similarity_calculator.dart';
import 'phonetic_matcher.dart';
import 'stemmer.dart';
import 'constants.dart';

/// Main Tokenizer class with comprehensive text processing capabilities
///
/// Built with 95% AI assistance using Claude (Anthropic)
class Tokenizer {
  /// Configuration for this tokenizer instance
  final TokenizerConfig config;

  /// Internal cache for tokenization results
  final Map<String, List<String>> _tokenCache = {};

  /// Internal cache for similarity results
  final Map<String, double> _similarityCache = {};

  /// Creates a new tokenizer with optional configuration
  Tokenizer({TokenizerConfig? config})
    : config = config ?? const TokenizerConfig();

  /// Tokenize text based on configuration
  ///
  /// Example:
  /// ```dart
  /// final tokenizer = Tokenizer();
  /// final tokens = tokenizer.tokenize('مرحباً بك');
  /// print(tokens); // [مرحبا, بك]
  /// ```
  List<String> tokenize(String text) {
    if (text.isEmpty) return [];

    // Check cache first
    if (config.enableCaching && _tokenCache.containsKey(text)) {
      return _tokenCache[text]!;
    }

    String processedText = text;

    // Detect and process Arabic
    final lang = detectLanguage(text);
    if ((lang == Language.arabic || lang == Language.mixed) &&
        config.normalizeArabic) {
      processedText = ArabicProcessor.normalize(processedText);
    }

    // Apply lowercase if configured
    if (config.toLowerCase) {
      processedText = processedText.toLowerCase();
    }

    List<String> tokens;

    // Apply tokenization strategy
    switch (config.type) {
      case TokenizationType.word:
        tokens = _tokenizeByWord(processedText);
      case TokenizationType.sentence:
        tokens = _tokenizeBySentence(processedText);
      case TokenizationType.character:
        tokens = _tokenizeByCharacter(processedText);
      case TokenizationType.whitespace:
        tokens = _tokenizeByWhitespace(processedText);
      case TokenizationType.ngram:
        tokens = _tokenizeByNgram(processedText);
      case TokenizationType.custom:
        tokens = _tokenizeByCustomPattern(processedText);
    }

    // Remove punctuation if configured
    if (config.removePunctuation) {
      tokens = tokens
          .map((t) => t.replaceAll(TokenizerConstants.punctuation, ''))
          .toList();
      tokens.removeWhere((t) => t.isEmpty);
    }

    // Apply stemming if configured
    if (config.enableStemming && lang == Language.arabic) {
      tokens = tokens.map((t) => ArabicStemmer.stem(t)).toList();
    }

    // Remove stop words if configured
    if (config.removeStopWords) {
      final stopWords = config.stopWords.isEmpty
          ? {
              ...TokenizerConstants.defaultEnglishStopWords,
              ...TokenizerConstants.defaultArabicStopWords,
            }
          : config.stopWords;
      tokens = tokens
          .where((t) => !stopWords.contains(t.toLowerCase()))
          .toList();
    }

    // Cache result
    if (config.enableCaching) {
      _manageCacheSize();
      _tokenCache[text] = tokens;
    }

    return tokens;
  }

  /// Tokenize by words (supports Arabic and English)
  List<String> _tokenizeByWord(String text) {
    return text
        .split(TokenizerConstants.wordSeparators)
        .where((w) => w.isNotEmpty)
        .toList();
  }

  /// Tokenize by sentences
  List<String> _tokenizeBySentence(String text) {
    return text
        .split(TokenizerConstants.sentenceTerminators)
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  /// Tokenize by characters
  List<String> _tokenizeByCharacter(String text) {
    return text.split('').where((c) => c.trim().isNotEmpty).toList();
  }

  /// Tokenize by whitespace
  List<String> _tokenizeByWhitespace(String text) {
    return text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  }

  /// Tokenize by n-grams
  List<String> _tokenizeByNgram(String text) {
    final words = text.split(RegExp(r'\s+'));
    final n = config.ngramSize;
    final ngrams = <String>[];

    if (words.length < n) return [text];

    for (int i = 0; i <= words.length - n; i++) {
      ngrams.add(words.sublist(i, i + n).join(' '));
    }

    return ngrams;
  }

  /// Tokenize by custom regex pattern
  List<String> _tokenizeByCustomPattern(String text) {
    if (config.customPattern == null) {
      return _tokenizeByWord(text);
    }

    return config.customPattern!
        .allMatches(text)
        .map((m) => m.group(0)!)
        .toList();
  }

  /// Calculate Levenshtein distance between two strings
  int levenshteinDistance(String s1, String s2) {
    return SimilarityCalculator.levenshteinDistance(s1, s2);
  }

  /// Calculate similarity percentage between two words
  double wordSimilarityPercentage(String word1, String word2) {
    return SimilarityCalculator.stringSimilarity(word1, word2);
  }

  /// Find the best matching word from a list
  WordSimilarity? findBestMatch(String word, List<String> candidates) {
    if (candidates.isEmpty) return null;

    double bestSimilarity = 0.0;
    String? bestMatch;

    for (final candidate in candidates) {
      double similarity;

      if (config.usePhoneticMatching && ArabicProcessor.hasArabic(word)) {
        similarity = PhoneticMatcher.calculatePhoneticSimilarity(
          word,
          candidate,
        );
      } else {
        similarity = wordSimilarityPercentage(word, candidate);
      }

      if (similarity > bestSimilarity && similarity >= config.fuzzyThreshold) {
        bestSimilarity = similarity;
        bestMatch = candidate;
      }
    }

    if (bestMatch != null) {
      return WordSimilarity(
        word1: word,
        word2: bestMatch,
        similarity: bestSimilarity,
      );
    }

    return null;
  }

  /// Detect language of text
  Language detectLanguage(String text) {
    if (text.isEmpty) return Language.unknown;

    final arabicMatches = TokenizerConstants.patterns['arabicWord']!
        .allMatches(text)
        .length;
    final englishMatches = TokenizerConstants.patterns['englishWord']!
        .allMatches(text)
        .length;

    if (arabicMatches == 0 && englishMatches == 0) return Language.unknown;
    if (arabicMatches > 0 && englishMatches > 0) return Language.mixed;
    if (arabicMatches > englishMatches) return Language.arabic;
    return Language.english;
  }

  /// Check if text contains Arabic numbers
  bool hasArabicNumbers(String text) {
    return ArabicProcessor.hasArabicNumbers(text);
  }

  /// Check if text contains English numbers
  bool hasEnglishNumbers(String text) {
    return ArabicProcessor.hasEnglishNumbers(text);
  }

  /// Extract all numbers from text
  Map<String, List<String>> extractNumbers(String text) {
    return ArabicProcessor.extractNumbers(text);
  }

  /// Convert Arabic numbers to English numbers
  String arabicToEnglishNumbers(String text) {
    return ArabicProcessor.arabicToEnglishNumbers(text);
  }

  /// Convert English numbers to Arabic numbers
  String englishToArabicNumbers(String text) {
    return ArabicProcessor.englishToArabicNumbers(text);
  }

  /// Normalize Arabic text
  String normalizeArabicText(String text) {
    return ArabicProcessor.normalize(text);
  }

  /// Calculate fuzzy Jaccard similarity
  double fuzzyJaccardSimilarity(String text1, String text2) {
    final cacheKey = '${text1}_${text2}_jaccard';
    if (config.enableCaching && _similarityCache.containsKey(cacheKey)) {
      return _similarityCache[cacheKey]!;
    }

    final tokens1 = tokenize(text1);
    final tokens2 = tokenize(text2);

    if (tokens1.isEmpty && tokens2.isEmpty) return 100.0;
    if (tokens1.isEmpty || tokens2.isEmpty) return 0.0;

    double result;

    if (!config.useFuzzyMatching) {
      final set1 = tokens1.toSet();
      final set2 = tokens2.toSet();
      result = SimilarityCalculator.jaccardSimilarity(set1, set2) * 100;
    } else {
      // Fuzzy matching
      final matched = <String>{};
      double totalSimilarity = 0.0;
      int matchCount = 0;

      for (final token1 in tokens1) {
        final bestMatch = findBestMatch(
          token1,
          tokens2.where((t) => !matched.contains(t)).toList(),
        );
        if (bestMatch != null) {
          matched.add(bestMatch.word2);
          totalSimilarity += bestMatch.similarity;
          matchCount++;
        }
      }

      final avgSimilarity = matchCount > 0 ? totalSimilarity / matchCount : 0.0;
      final coverage = matchCount / max(tokens1.length, tokens2.length);

      result = (avgSimilarity * coverage) * 100;
    }

    if (config.enableCaching) {
      _similarityCache[cacheKey] = result;
    }

    return result;
  }

  /// Calculate fuzzy Cosine similarity
  double fuzzyCosineSimilarity(String text1, String text2) {
    final cacheKey = '${text1}_${text2}_cosine';
    if (config.enableCaching && _similarityCache.containsKey(cacheKey)) {
      return _similarityCache[cacheKey]!;
    }

    final tokens1 = tokenize(text1);
    final tokens2 = tokenize(text2);

    if (tokens1.isEmpty || tokens2.isEmpty) return 0.0;

    double result;

    if (!config.useFuzzyMatching) {
      final freq1 = tokenFrequency(text1);
      final freq2 = tokenFrequency(text2);
      result = SimilarityCalculator.cosineSimilarity(freq1, freq2) * 100;
    } else {
      // Fuzzy cosine with phonetic matching
      double dotProduct = 0.0;
      double magnitude1 = 0.0;
      double magnitude2 = 0.0;

      final allTokens = {...tokens1, ...tokens2};

      for (final token in allTokens) {
        final f1 = tokens1.where((t) => t == token).length.toDouble();
        final f2 = tokens2.where((t) => t == token).length.toDouble();

        magnitude1 += f1 * f1;
        magnitude2 += f2 * f2;
        dotProduct += f1 * f2;
      }

      if (magnitude1 == 0 || magnitude2 == 0) {
        result = 0.0;
      } else {
        result = (dotProduct / (sqrt(magnitude1) * sqrt(magnitude2))) * 100;
      }
    }

    if (config.enableCaching) {
      _similarityCache[cacheKey] = result;
    }

    return result;
  }

  /// Compare one sentence with multiple sentences
  List<SimilarityResult> compareSentences(
    String querySentence,
    List<String> targetSentences, {
    bool useCosineSimilarity = true,
    bool showWordMatches = true,
  }) {
    final results = <SimilarityResult>[];

    for (int i = 0; i < targetSentences.length; i++) {
      final similarity = useCosineSimilarity
          ? fuzzyCosineSimilarity(querySentence, targetSentences[i])
          : fuzzyJaccardSimilarity(querySentence, targetSentences[i]);

      List<WordSimilarity> wordMatches = [];

      if (showWordMatches && config.useFuzzyMatching) {
        final queryTokens = tokenize(querySentence);
        final targetTokens = tokenize(targetSentences[i]);

        for (final queryToken in queryTokens) {
          final match = findBestMatch(queryToken, targetTokens);
          if (match != null) {
            wordMatches.add(match);
          }
        }
      }

      results.add(
        SimilarityResult(
          sentence: targetSentences[i],
          percentage: similarity,
          rank: 0,
          wordMatches: wordMatches,
        ),
      );
    }

    // Sort by percentage (descending)
    results.sort((a, b) => b.percentage.compareTo(a.percentage));

    // Assign ranks
    for (int i = 0; i < results.length; i++) {
      results[i] = SimilarityResult(
        sentence: results[i].sentence,
        percentage: results[i].percentage,
        rank: i + 1,
        wordMatches: results[i].wordMatches,
      );
    }

    return results;
  }

  /// Get token count
  int countTokens(String text) {
    return tokenize(text).length;
  }

  /// Get unique tokens
  Set<String> uniqueTokens(String text) {
    return tokenize(text).toSet();
  }

  /// Get token frequency map
  Map<String, int> tokenFrequency(String text) {
    final tokens = tokenize(text);
    final frequency = <String, int>{};

    for (final token in tokens) {
      frequency[token] = (frequency[token] ?? 0) + 1;
    }

    return frequency;
  }

  /// Reconstruct text from tokens
  String detokenize(List<String> tokens, {String separator = ' '}) {
    return tokens.join(separator);
  }

  /// Get comprehensive text statistics
  TextStatistics getStatistics(String text) {
    final tokens = tokenize(text);
    final unique = uniqueTokens(text);
    final frequency = tokenFrequency(text);

    int arabicWords = 0;
    int englishWords = 0;
    int mixedWords = 0;
    double totalLength = 0;

    for (final token in tokens) {
      totalLength += token.length;
      final lang = detectLanguage(token);

      switch (lang) {
        case Language.arabic:
          arabicWords++;
        case Language.english:
          englishWords++;
        case Language.mixed:
          mixedWords++;
        case Language.unknown:
          break;
      }
    }

    final avgLength = tokens.isNotEmpty ? totalLength / tokens.length : 0.0;
    final diversity = tokens.isNotEmpty ? unique.length / tokens.length : 0.0;

    return TextStatistics(
      totalWords: tokens.length,
      uniqueWords: unique.length,
      averageWordLength: avgLength,
      lexicalDiversity: diversity,
      arabicWords: arabicWords,
      englishWords: englishWords,
      mixedWords: mixedWords,
      frequency: frequency,
    );
  }



  /// Batch tokenize multiple texts
  List<List<String>> tokenizeBatch(List<String> texts) {
    return texts.map((text) => tokenize(text)).toList();
  }

  /// Compare all pairs of sentences (similarity matrix)
  List<List<double>> compareAllPairs(List<String> texts) {
    final matrix = <List<double>>[];

    for (int i = 0; i < texts.length; i++) {
      final row = <double>[];
      for (int j = 0; j < texts.length; j++) {
        if (i == j) {
          row.add(100.0);
        } else {
          row.add(fuzzyCosineSimilarity(texts[i], texts[j]));
        }
      }
      matrix.add(row);
    }

    return matrix;
  }

  /// Clear all caches
  void clearCache() {
    _tokenCache.clear();
    _similarityCache.clear();
  }

  /// Manage cache size
  void _manageCacheSize() {
    if (_tokenCache.length > config.cacheSize) {
      final keysToRemove = _tokenCache.keys
          .take(_tokenCache.length - config.cacheSize ~/ 2)
          .toList();
      for (final key in keysToRemove) {
        _tokenCache.remove(key);
      }
    }

    if (_similarityCache.length > config.cacheSize) {
      final keysToRemove = _similarityCache.keys
          .take(_similarityCache.length - config.cacheSize ~/ 2)
          .toList();
      for (final key in keysToRemove) {
        _similarityCache.remove(key);
      }
    }
  }

  /// Get cache statistics
  Map<String, int> getCacheStats() {
    return {
      'tokenCacheSize': _tokenCache.length,
      'similarityCacheSize': _similarityCache.length,
      'maxCacheSize': config.cacheSize,
    };
  }
}
