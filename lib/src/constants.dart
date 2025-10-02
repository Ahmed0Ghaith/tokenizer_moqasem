/// Constants and predefined patterns
library;

/// Constants used throughout the tokenizer
class TokenizerConstants {
  /// Default English stop words
  static const Set<String> defaultEnglishStopWords = {
    'a',
    'an',
    'and',
    'are',
    'as',
    'at',
    'be',
    'by',
    'for',
    'from',
    'has',
    'he',
    'in',
    'is',
    'it',
    'its',
    'of',
    'on',
    'that',
    'the',
    'to',
    'was',
    'will',
    'with',
    'this',
    'but',
    'they',
    'have',
    'or',
    'been',
    'had',
    'having',
    'do',
    'does',
    'did',
    'doing',
    'would',
    'should',
    'could',
    'ought',
    'i',
    'you',
    'she',
    'we',
    'who',
    'what',
    'where',
    'when',
    'why',
    'how',
    'all',
    'each',
    'every',
  };

  /// Default Arabic stop words
  static const Set<String> defaultArabicStopWords = {
    'في',
    'من',
    'إلى',
    'على',
    'عن',
    'هذا',
    'هذه',
    'ذلك',
    'التي',
    'الذي',
    'أن',
    'كان',
    'لقد',
    'قد',
    'لم',
    'لن',
    'كل',
    'بعض',
    'أو',
    'و',
    'ف',
    'إن',
    'أنا',
    'أنت',
    'هو',
    'هي',
    'نحن',
    'هم',
    'ما',
    'لا',
    'نعم',
    'إذا',
    'لكن',
    'حتى',
    'بل',
    'ثم',
    'كذلك',
    'أيضا',
    'ايضا',
    'عند',
    'بين',
    'تحت',
    'فوق',
    'أمام',
    'خلف',
    'مع',
    'ضد',
    'حول',
    'عبر',
  };

  /// Common regex patterns
  static final Map<String, RegExp> patterns = {
    'email': RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'),
    'url': RegExp(
      r'https?://(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&/=]*)',
    ),
    'phone': RegExp(
      r'(?:\+?\d{1,3}[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}',
    ),
    'hashtag': RegExp(r'#[\w\u0600-\u06FF]+'),
    'mention': RegExp(r'@[\w\u0600-\u06FF]+'),
    'arabicWord': RegExp(r'[\u0600-\u06FF]+'),
    'englishWord': RegExp(r'[a-zA-Z]+'),
    'number': RegExp(r'\d+'),
    'arabicNumber': RegExp(r'[\u0660-\u0669]+'),
  };

  /// Arabic character ranges
  static const String arabicRange = '\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF';

  /// Sentence terminators
  static final RegExp sentenceTerminators = RegExp(r'[.!?؟]+');

  /// Word separators
  static final RegExp wordSeparators = RegExp(r'\s+|(?<=[.!?؟،])\s*');

  /// Punctuation marks
  static final RegExp punctuation = RegExp(
    r'[^\w\s\u0600-\u06FF\u0660-\u0669]',
  );

  /// Arabic diacritics (Tashkeel)
  static final RegExp arabicDiacritics = RegExp(r'[\u064B-\u065F\u0670]');

  /// Default cache size
  static const int defaultCacheSize = 1000;

  /// Default fuzzy threshold
  static const double defaultFuzzyThreshold = 0.7;

  /// Default n-gram size
  static const int defaultNgramSize = 2;

  /// Maximum token length
  static const int maxTokenLength = 100;

  /// Minimum token length
  static const int minTokenLength = 1;

  /// Version
  static const String version = '1.0.0';

  /// Library name
  static const String libraryName = 'Tokenizer Moqasem';

  /// AI disclaimer
  static const String aiDisclaimer =
      'This library was created with 95% AI assistance using Claude (Anthropic)';
}
