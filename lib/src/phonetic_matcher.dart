/// Phonetic matching for Arabic words
library;

import 'dart:math';
import 'arabic_processor.dart';
import 'models.dart';

/// Handles phonetic matching for Arabic words
class PhoneticMatcher {
  /// Calculate phonetic similarity between two Arabic words
  static double calculatePhoneticSimilarity(String word1, String word2) {
    if (word1 == word2) {
      return 1.0;
    }
    if (word1.isEmpty || word2.isEmpty) {
      return 0.0;
    }

    // Normalize both words
    final normalized1 = ArabicProcessor.normalize(word1);
    final normalized2 = ArabicProcessor.normalize(word2);

    if (normalized1 == normalized2) {
      return 1.0;
    }

    // Calculate character-level phonetic similarity
    var matches = 0;
    var comparisons = 0;

    final len1 = normalized1.length;
    final len2 = normalized2.length;
    final maxLen = max(len1, len2);

    // Compare each position
    for (var i = 0; i < maxLen; i++) {
      if (i < len1 && i < len2) {
        comparisons++;
        if (ArabicProcessor.arePhoneticallySimilar(
          normalized1[i],
          normalized2[i],
        )) {
          matches++;
        }
      }
    }

    if (comparisons == 0) {
      return 0.0;
    }

    // Calculate similarity with length penalty
    final matchRatio = matches / comparisons;
    final lengthRatio = min(len1, len2) / maxLen;

    return matchRatio * 0.7 + lengthRatio * 0.3;
  }

  /// Find phonetically similar words from a list
  static List<PhoneticMatch> findPhoneticMatches(
    String word,
    List<String> candidates, {
    double threshold = 0.6,
  }) {
    final matches = <PhoneticMatch>[];

    for (final candidate in candidates) {
      final score = calculatePhoneticSimilarity(word, candidate);
      if (score >= threshold && word != candidate) {
        matches.add(PhoneticMatch(word: word, match: candidate, score: score));
      }
    }

    // Sort by score (descending)
    matches.sort((a, b) => b.score.compareTo(a.score));

    return matches;
  }

  /// Get phonetic code for Arabic word (similar to Soundex)
  static String getPhoneticCode(String word) {
    if (word.isEmpty) {
      return '';
    }

    final normalized = ArabicProcessor.normalize(word);
    final buffer = StringBuffer();

    // Keep first character
    if (normalized.isNotEmpty) {
      buffer.write(normalized[0]);
    }

    // Map similar sounding characters to same code
    for (var i = 1; i < normalized.length; i++) {
      final char = normalized[i];
      final code = _getCharCode(char);

      // Only add if different from previous
      if (buffer.isEmpty || buffer.toString()[buffer.length - 1] != code) {
        buffer.write(code);
      }
    }

    return buffer.toString();
  }

  /// Get character code for phonetic grouping
  static String _getCharCode(String char) {
    // Stops
    if ('بتدطكق'.contains(char)) {
      return '1';
    }

    // Fricatives
    if ('ثذسشصضظفهـ'.contains(char)) {
      return '2';
    }

    // Nasals
    if ('من'.contains(char)) {
      return '3';
    }

    // Liquids
    if ('لر'.contains(char)) {
      return '4';
    }

    // Pharyngeal/Glottal
    if ('حخعغهء'.contains(char)) {
      return '5';
    }

    // Vowels
    if ('اويى'.contains(char)) {
      return '6';
    }

    // Emphatics
    if ('صضطظ'.contains(char)) {
      return '7';
    }

    return '0';
  }

  /// Compare phonetic codes
  static double comparePhoneticCodes(String code1, String code2) {
    if (code1 == code2) {
      return 1.0;
    }
    if (code1.isEmpty || code2.isEmpty) {
      return 0.0;
    }

    var matches = 0;
    final minLen = min(code1.length, code2.length);

    for (var i = 0; i < minLen; i++) {
      if (code1[i] == code2[i]) {
        matches++;
      }
    }

    final maxLen = max(code1.length, code2.length);
    return matches / maxLen;
  }
}
