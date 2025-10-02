/// Arabic text processing utilities
library;

/// Handles advanced Arabic text processing
class ArabicProcessor {
  /// Normalize Arabic text (remove diacritics and normalize characters)
  static String normalize(String text) {
    if (text.isEmpty) {
      return text;
    }

    var normalized = text;

    // Remove Arabic diacritics (Tashkeel)
    normalized = normalized.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');

    // Normalize Alef variations
    normalized = normalized.replaceAll(RegExp(r'[إأآا]'), 'ا');

    // Normalize Taa Marbuta
    normalized = normalized.replaceAll('ة', 'ه');

    // Normalize Hamza variations
    normalized = normalized.replaceAll(RegExp(r'[ؤئ]'), 'ء');

    // Normalize Yaa
    normalized = normalized.replaceAll('ى', 'ي');

    // Remove Tatweel (Kashida)
    normalized = normalized.replaceAll('ـ', '');

    return normalized;
  }

  /// Remove definite article (ال) from beginning of words
  static String removeDefiniteArticle(String word) {
    if (word.startsWith('ال') && word.length > 2) {
      return word.substring(2);
    }
    return word;
  }

  /// Remove attached pronouns from end of words
  static String removeAttachedPronouns(String word) {
    final pronouns = ['ها', 'هم', 'هن', 'كم', 'كن', 'نا', 'ني', 'ه', 'ك', 'ي'];

    for (final pronoun in pronouns) {
      if (word.endsWith(pronoun) && word.length > pronoun.length + 1) {
        return word.substring(0, word.length - pronoun.length);
      }
    }

    return word;
  }

  /// Detect if text contains Arabic characters
  static bool hasArabic(String text) {
    return RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]').hasMatch(text);
  }

  /// Detect if text contains Arabic numbers (٠-٩)
  static bool hasArabicNumbers(String text) {
    return RegExp(r'[\u0660-\u0669]').hasMatch(text);
  }

  /// Detect if text contains English numbers (0-9)
  static bool hasEnglishNumbers(String text) {
    return RegExp(r'[0-9]').hasMatch(text);
  }

  /// Extract all numbers from text
  static Map<String, List<String>> extractNumbers(String text) {
    final arabicNumbers = RegExp(
      r'[\u0660-\u0669]+',
    ).allMatches(text).map((m) => m.group(0)!).toList();

    final englishNumbers = RegExp(
      r'[0-9]+',
    ).allMatches(text).map((m) => m.group(0)!).toList();

    return {'arabic': arabicNumbers, 'english': englishNumbers};
  }

  /// Convert Arabic numbers to English numbers
  static String arabicToEnglishNumbers(String text) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = text;

    for (var i = 0; i < arabicDigits.length; i++) {
      result = result.replaceAll(arabicDigits[i], i.toString());
    }

    return result;
  }

  /// Convert English numbers to Arabic numbers
  static String englishToArabicNumbers(String text) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = text;

    for (var i = 0; i < arabicDigits.length; i++) {
      result = result.replaceAll(i.toString(), arabicDigits[i]);
    }

    return result;
  }

  /// Get character type for Arabic phonetic analysis
  static String getCharacterType(String char) {
    if (char.isEmpty) {
      return 'unknown';
    }

    // Pharyngeal and glottal consonants
    if ('حخعغهء'.contains(char)) {
      return 'pharyngeal';
    }

    // Emphatic consonants
    if ('صضطظ'.contains(char)) {
      return 'emphatic';
    }

    // Sibilants
    if ('سشصض'.contains(char)) {
      return 'sibilant';
    }

    // Stops
    if ('بتدطكق'.contains(char)) {
      return 'stop';
    }

    // Fricatives
    if ('ثذسشصضظفهـ'.contains(char)) {
      return 'fricative';
    }

    // Nasals
    if ('من'.contains(char)) {
      return 'nasal';
    }

    // Liquids
    if ('لر'.contains(char)) {
      return 'liquid';
    }

    // Vowels
    if ('اويى'.contains(char)) {
      return 'vowel';
    }

    return 'consonant';
  }

  /// Check if two Arabic characters are phonetically similar
  static bool arePhoneticallySimilar(String char1, String char2) {
    if (char1 == char2) {
      return true;
    }

    // Similar sounding groups
    final similarGroups = [
      ['ت', 'ط'],
      ['د', 'ض'],
      ['س', 'ص'],
      ['ذ', 'ز', 'ظ'],
      ['ث', 'س'],
      ['ق', 'ك'],
      ['ا', 'أ', 'إ', 'آ'],
      ['ه', 'ة'],
      ['ي', 'ى'],
      ['و', 'ؤ'],
    ];

    for (final group in similarGroups) {
      if (group.contains(char1) && group.contains(char2)) {
        return true;
      }
    }

    return false;
  }

  /// Clean and prepare Arabic text for processing
  static String clean(String text) {
    var cleaned = text;

    // Remove extra whitespace
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Normalize
    cleaned = normalize(cleaned);

    return cleaned;
  }

  /// Check if word is a stop word
  static bool isStopWord(String word, Set<String> stopWords) {
    return stopWords.contains(word.toLowerCase());
  }

  /// Extract root-like pattern (simplified stemming)
  static String extractPattern(String word) {
    var pattern = word;

    // Remove prefixes
    final prefixes = ['ال', 'و', 'ف', 'ب', 'ك', 'ل'];
    for (final prefix in prefixes) {
      if (pattern.startsWith(prefix) && pattern.length > prefix.length + 2) {
        pattern = pattern.substring(prefix.length);
        break;
      }
    }

    // Remove suffixes
    final suffixes = [
      'ها',
      'هم',
      'هن',
      'كم',
      'كن',
      'ني',
      'ات',
      'ين',
      'ون',
      'ان',
      'ه',
      'ك',
      'ي',
    ];
    for (final suffix in suffixes) {
      if (pattern.endsWith(suffix) && pattern.length > suffix.length + 2) {
        pattern = pattern.substring(0, pattern.length - suffix.length);
        break;
      }
    }

    return pattern;
  }
}
