/// Arabic stemming and root extraction
library;

import 'arabic_processor.dart';

/// Handles Arabic word stemming and root extraction
class ArabicStemmer {
  /// Common prefixes in Arabic
  static const List<String> prefixes = [
    'وال',
    'بال',
    'كال',
    'فال',
    'لل',
    'ال',
    'و',
    'ف',
    'ب',
    'ك',
    'ل',
  ];

  /// Common suffixes in Arabic
  static const List<String> suffixes = [
    'كما',
    'هما',
    'تما',
    'كم',
    'كن',
    'ها',
    'هم',
    'هن',
    'نا',
    'ني',
    'وا',
    'ين',
    'ون',
    'ات',
    'ان',
    'تن',
    'تم',
    'ه',
    'ي',
    'ك',
    'ت',
    'ا',
    'ن',
  ];

  /// Extract stem from Arabic word
  static String stem(String word) {
    if (word.length < 3) {
      return word;
    }

    var stemmed = ArabicProcessor.normalize(word);

    // Remove prefixes
    stemmed = _removePrefixes(stemmed);

    // Remove suffixes
    stemmed = _removeSuffixes(stemmed);

    // Don't return stems shorter than 2 characters
    return stemmed.length >= 2 ? stemmed : word;
  }

  /// Remove prefixes from word
  static String _removePrefixes(String word) {
    for (final prefix in prefixes) {
      if (word.startsWith(prefix) && word.length > prefix.length + 2) {
        return word.substring(prefix.length);
      }
    }
    return word;
  }

  /// Remove suffixes from word
  static String _removeSuffixes(String word) {
    for (final suffix in suffixes) {
      if (word.endsWith(suffix) && word.length > suffix.length + 2) {
        return word.substring(0, word.length - suffix.length);
      }
    }
    return word;
  }

  /// Extract potential root (simplified - returns 3-4 letter core)
  static String extractRoot(String word) {
    final root = stem(word);

    // Arabic roots are typically 3-4 letters
    if (root.length <= 4) {
      return root;
    }

    // Remove weak letters (حروف العلة)
    final weakLetters = {'ا', 'و', 'ي', 'ى'};
    final chars = root.split('');
    final strongChars = chars.where((c) => !weakLetters.contains(c)).toList();

    if (strongChars.length >= 3) {
      return strongChars.take(3).join();
    }

    return root;
  }

  /// Check if two words share the same root
  static bool haveSameRoot(String word1, String word2) {
    final root1 = extractRoot(word1);
    final root2 = extractRoot(word2);

    return root1 == root2 && root1.length >= 2;
  }

  /// Get all possible stems from a word (light, medium, heavy stemming)
  static Map<String, String> getAllStems(String word) {
    final normalized = ArabicProcessor.normalize(word);

    return {
      'original': word,
      'normalized': normalized,
      'light': _removePrefixes(normalized),
      'medium': stem(word),
      'heavy': extractRoot(word),
    };
  }
}
