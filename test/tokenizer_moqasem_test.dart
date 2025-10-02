import 'package:flutter_test/flutter_test.dart';
import 'package:tokenizer_moqasem/tokenizer_moqasem.dart';

void main() {
  group('Tokenizer Tests', () {
    test('Basic word tokenization', () {
      final tokenizer = Tokenizer();
      final tokens = tokenizer.tokenize('Hello world');
      expect(tokens, ['Hello', 'world']);
    });

    test('Arabic word tokenization', () {
      final tokenizer = Tokenizer();
      final tokens = tokenizer.tokenize('مرحباً بك');
      expect(tokens.length, 2);
    });

    test('Token count', () {
      final tokenizer = Tokenizer();
      expect(tokenizer.countTokens('one two three'), 3);
    });

    test('Unique tokens', () {
      final tokenizer = Tokenizer();
      final unique = tokenizer.uniqueTokens('one two one three');
      expect(unique.length, 3);
    });

    test('Lowercase conversion', () {
      final tokenizer = Tokenizer(config: TokenizerConfig(toLowerCase: true));
      final tokens = tokenizer.tokenize('Hello World');
      expect(tokens, ['hello', 'world']);
    });

    test('Stop words removal', () {
      final tokenizer = Tokenizer(
        config: TokenizerConfig(removeStopWords: true, stopWords: {'the', 'a'}),
      );
      final tokens = tokenizer.tokenize('the cat and a dog');
      expect(tokens, ['cat', 'and', 'dog']);
    });
  });

  group('Arabic Processing Tests', () {
    test('Arabic normalization', () {
      final normalized = ArabicProcessor.normalize('أَلسَّلامُ');
      expect(normalized.contains(RegExp(r'[\u064B-\u065F]')), false);
    });

    test('Arabic number conversion', () {
      final tokenizer = Tokenizer();
      final result = tokenizer.arabicToEnglishNumbers('٠١٢٣');
      expect(result, '0123');
    });

    test('Language detection - Arabic', () {
      final tokenizer = Tokenizer();
      final lang = tokenizer.detectLanguage('مرحباً');
      expect(lang, Language.arabic);
    });

    test('Language detection - English', () {
      final tokenizer = Tokenizer();
      final lang = tokenizer.detectLanguage('Hello');
      expect(lang, Language.english);
    });

    test('Language detection - Mixed', () {
      final tokenizer = Tokenizer();
      final lang = tokenizer.detectLanguage('Hello مرحباً');
      expect(lang, Language.mixed);
    });

    test('Definite article removal', () {
      final result = ArabicProcessor.removeDefiniteArticle('الكتاب');
      expect(result, 'كتاب');
    });
  });

  group('Similarity Tests', () {
    test('Exact match similarity', () {
      final tokenizer = Tokenizer();
      final sim = tokenizer.wordSimilarityPercentage('test', 'test');
      expect(sim, 1.0);
    });

    test('Different strings similarity', () {
      final tokenizer = Tokenizer();
      final sim = tokenizer.wordSimilarityPercentage('test', 'tests');
      expect(sim, greaterThan(0.7));
    });

    test('Fuzzy Jaccard similarity', () {
      final tokenizer = Tokenizer(
        config: TokenizerConfig(useFuzzyMatching: true),
      );
      final sim = tokenizer.fuzzyJaccardSimilarity(
        'I love programming',
        'I love coding',
      );
      expect(sim, greaterThan(50.0));
    });

    test('Levenshtein distance', () {
      final tokenizer = Tokenizer();
      final distance = tokenizer.levenshteinDistance('kitten', 'sitting');
      expect(distance, 3);
    });
  });

  group('N-gram Tests', () {
    test('Bigram tokenization', () {
      final tokenizer = Tokenizer(
        config: TokenizerConfig(type: TokenizationType.ngram, ngramSize: 2),
      );
      final tokens = tokenizer.tokenize('one two three');
      expect(tokens, ['one two', 'two three']);
    });

    test('Trigram tokenization', () {
      final tokenizer = Tokenizer(
        config: TokenizerConfig(type: TokenizationType.ngram, ngramSize: 3),
      );
      final tokens = tokenizer.tokenize('one two three four');
      expect(tokens, ['one two three', 'two three four']);
    });
  });

  group('Sentence Comparison Tests', () {
    test('Compare sentences with ranking', () {
      final tokenizer = Tokenizer();
      final results = tokenizer.compareSentences('I love programming', [
        'I love coding',
        'I hate bugs',
        'Programming is fun',
      ]);
      expect(results.length, 3);
      expect(results[0].rank, 1);
      expect(results[0].percentage, greaterThan(results[1].percentage));
    });

    test('Arabic sentence comparison', () {
      final tokenizer = Tokenizer(
        config: TokenizerConfig(useFuzzyMatching: true),
      );
      final results = tokenizer.compareSentences('مرحباً بك', [
        'مرحبا بكم',
        'أهلاً وسهلاً',
        'الطقس جميل',
      ]);
      expect(results.length, 3);
      expect(results[0].percentage, greaterThan(results[2].percentage));
    });
  });

  group('Stemming Tests', () {
    test('Arabic stemming', () {
      final stem = ArabicStemmer.stem('المدرسة');
      expect(stem.length, lessThan('المدرسة'.length));
    });

    test('Root extraction', () {
      final root = ArabicStemmer.extractRoot('كاتبون');
      expect(root.length, greaterThanOrEqualTo(3));
      expect(root.length, lessThanOrEqualTo(4));
    });
  });


  group('Configuration Tests', () {
    test('Config to/from JSON', () {
      final config = TokenizerConfig(
        type: TokenizationType.word,
        toLowerCase: true,
        fuzzyThreshold: 0.8,
      );
      final json = config.toJson();
      final restored = TokenizerConfig.fromJson(json);
      expect(restored.type, config.type);
      expect(restored.toLowerCase, config.toLowerCase);
      expect(restored.fuzzyThreshold, config.fuzzyThreshold);
    });

    test('Arabic optimized config', () {
      final config = TokenizerConfig.arabicOptimized();
      expect(config.normalizeArabic, true);
      expect(config.usePhoneticMatching, true);
    });

    test('English optimized config', () {
      final config = TokenizerConfig.englishOptimized();
      expect(config.toLowerCase, true);
      expect(config.removeStopWords, true);
    });
  });

  group('Phonetic Matching Tests', () {
    test('Phonetic similarity', () {
      final sim = PhoneticMatcher.calculatePhoneticSimilarity('قال', 'دال');
      expect(sim, greaterThan(0.5));
    });

    test('Phonetic code generation', () {
      final code1 = PhoneticMatcher.getPhoneticCode('كتب');
      final code2 = PhoneticMatcher.getPhoneticCode('كتب');
      expect(code1, code2);
    });
  });

  group('Edge Cases Tests', () {
    test('Empty string tokenization', () {
      final tokenizer = Tokenizer();
      final tokens = tokenizer.tokenize('');
      expect(tokens, isEmpty);
    });

    test('Single character', () {
      final tokenizer = Tokenizer();
      final tokens = tokenizer.tokenize('a');
      expect(tokens.length, 1);
    });

    test('Only whitespace', () {
      final tokenizer = Tokenizer();
      final tokens = tokenizer.tokenize('   ');
      expect(tokens, isEmpty);
    });

    test('Special characters', () {
      final tokenizer = Tokenizer(
        config: TokenizerConfig(removePunctuation: true),
      );
      final tokens = tokenizer.tokenize('Hello, world!');
      expect(tokens, ['Hello', 'world']);
    });
  });
}
