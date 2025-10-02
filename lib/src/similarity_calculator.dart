/// Similarity calculation algorithms
library;

import 'dart:math';

/// Handles various similarity calculations
class SimilarityCalculator {
  /// Calculate Levenshtein distance between two strings
  static int levenshteinDistance(String s1, String s2) {
    if (s1 == s2) {
      return 0;
    }
    if (s1.isEmpty) {
      return s2.length;
    }
    if (s2.isEmpty) {
      return s1.length;
    }

    final len1 = s1.length;
    final len2 = s2.length;
    final d = List<List<int>>.generate(
      len1 + 1,
      (i) => List.filled(len2 + 1, 0),
    );

    for (var i = 0; i <= len1; i++) {
      d[i][0] = i;
    }
    for (var j = 0; j <= len2; j++) {
      d[0][j] = j;
    }

    for (var i = 1; i <= len1; i++) {
      for (var j = 1; j <= len2; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        d[i][j] = min(
          min(d[i - 1][j] + 1, d[i][j - 1] + 1),
          d[i - 1][j - 1] + cost,
        );
      }
    }

    return d[len1][len2];
  }

  /// Calculate similarity percentage between two strings
  static double stringSimilarity(String s1, String s2) {
    if (s1 == s2) {
      return 1.0;
    }
    if (s1.isEmpty || s2.isEmpty) {
      return 0.0;
    }

    final maxLen = max(s1.length, s2.length);
    final distance = levenshteinDistance(s1, s2);

    return 1.0 - (distance / maxLen);
  }

  /// Calculate Jaccard similarity
  static double jaccardSimilarity(Set<String> set1, Set<String> set2) {
    if (set1.isEmpty && set2.isEmpty) {
      return 1.0;
    }
    if (set1.isEmpty || set2.isEmpty) {
      return 0.0;
    }

    final intersection = set1.intersection(set2).length;
    final union = set1.union(set2).length;

    return intersection / union;
  }

  /// Calculate Cosine similarity
  static double cosineSimilarity(
    Map<String, int> freq1,
    Map<String, int> freq2,
  ) {
    final allTokens = {...freq1.keys, ...freq2.keys};

    if (allTokens.isEmpty) {
      return 0.0;
    }

    var dotProduct = 0.0;
    var magnitude1 = 0.0;
    var magnitude2 = 0.0;

    for (final token in allTokens) {
      final f1 = freq1[token] ?? 0;
      final f2 = freq2[token] ?? 0;

      dotProduct += f1 * f2;
      magnitude1 += f1 * f1;
      magnitude2 += f2 * f2;
    }

    if (magnitude1 == 0 || magnitude2 == 0) {
      return 0.0;
    }

    return dotProduct / (sqrt(magnitude1) * sqrt(magnitude2));
  }

  /// Calculate Dice coefficient
  static double diceCoefficient(Set<String> set1, Set<String> set2) {
    if (set1.isEmpty && set2.isEmpty) {
      return 1.0;
    }
    if (set1.isEmpty || set2.isEmpty) {
      return 0.0;
    }

    final intersection = set1.intersection(set2).length;
    return (2.0 * intersection) / (set1.length + set2.length);
  }

  /// Calculate Overlap coefficient
  static double overlapCoefficient(Set<String> set1, Set<String> set2) {
    if (set1.isEmpty && set2.isEmpty) {
      return 1.0;
    }
    if (set1.isEmpty || set2.isEmpty) {
      return 0.0;
    }

    final intersection = set1.intersection(set2).length;
    final minSize = min(set1.length, set2.length);

    return intersection / minSize;
  }

  /// Calculate Hamming distance (for equal length strings)
  static int? hammingDistance(String s1, String s2) {
    if (s1.length != s2.length) {
      return null;
    }

    var distance = 0;
    for (var i = 0; i < s1.length; i++) {
      if (s1[i] != s2[i]) {
        distance++;
      }
    }

    return distance;
  }

  /// Calculate normalized Hamming distance
  static double? normalizedHammingDistance(String s1, String s2) {
    final distance = hammingDistance(s1, s2);
    if (distance == null || s1.isEmpty) {
      return null;
    }

    return 1.0 - (distance / s1.length);
  }

  /// Calculate Jaro similarity
  static double jaroSimilarity(String s1, String s2) {
    if (s1 == s2) {
      return 1.0;
    }
    if (s1.isEmpty || s2.isEmpty) {
      return 0.0;
    }

    final len1 = s1.length;
    final len2 = s2.length;

    final matchWindow = (max(len1, len2) / 2).floor() - 1;
    if (matchWindow < 1) {
      return s1 == s2 ? 1.0 : 0.0;
    }

    final s1Matches = List<bool>.filled(len1, false);
    final s2Matches = List<bool>.filled(len2, false);

    var matches = 0;
    var transpositions = 0;

    // Find matches
    for (var i = 0; i < len1; i++) {
      final start = max(0, i - matchWindow);
      final end = min(i + matchWindow + 1, len2);

      for (var j = start; j < end; j++) {
        if (s2Matches[j] || s1[i] != s2[j]) {
          continue;
        }
        s1Matches[i] = true;
        s2Matches[j] = true;
        matches++;
        break;
      }
    }

    if (matches == 0) {
      return 0.0;
    }

    // Count transpositions
    var k = 0;
    for (var i = 0; i < len1; i++) {
      if (!s1Matches[i]) {
        continue;
      }
      while (!s2Matches[k]) {
        k++;
      }
      if (s1[i] != s2[k]) {
        transpositions++;
      }
      k++;
    }

    return (matches / len1 +
            matches / len2 +
            (matches - transpositions / 2) / matches) /
        3.0;
  }

  /// Calculate Jaro-Winkler similarity
  static double jaroWinklerSimilarity(
    String s1,
    String s2, {
    double scalingFactor = 0.1,
  }) {
    final jaroSim = jaroSimilarity(s1, s2);

    // Find common prefix length (up to 4 characters)
    var prefixLength = 0;
    final minLen = min(min(s1.length, s2.length), 4);

    for (var i = 0; i < minLen; i++) {
      if (s1[i] == s2[i]) {
        prefixLength++;
      } else {
        break;
      }
    }

    return jaroSim + (prefixLength * scalingFactor * (1 - jaroSim));
  }
}
