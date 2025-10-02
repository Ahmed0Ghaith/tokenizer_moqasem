# Tokenizer Moqasem 


**Intelligent tokenization plugin with advanced Arabic support, fuzzy matching, and AI-powered text analysis.**

> ⚡ **AI Disclaimer:** This plugin was created with 95% AI assistance, showcasing the power and potential of modern AI-powered development tools.

## ✨ Features

### 🔤 Advanced Tokenization
- **Multiple Strategies**: Word, sentence, character, whitespace, n-gram, and custom regex patterns
- **Multi-Language Support**: Arabic, English, and mixed text
- **Smart Processing**: Configurable lowercase, punctuation removal, and stop words filtering

### 🎯 Fuzzy Matching
- **Levenshtein Distance**: Calculate edit distance between strings
- **Word Similarity**: Percentage-based similarity scoring
- **Typo Tolerance**: Find matches even with spelling errors
- **Configurable Threshold**: Adjust matching sensitivity

### 🇸🇦 Arabic Language Support
- **Text Normalization**: Automatic diacritics removal (Tashkeel)
- **Alef Variations**: Normalize أ، إ، آ → ا
- **Taa Marbuta**: Handle ة → ه conversion
- **Number Conversion**: Arabic numerals (٠-٩) to English (0-9)
- **Phonetic Matching**: Sound-based similarity for Arabic characters
- **Root Extraction**: Basic Arabic stemming

### 📊 Text Analysis
- **Similarity Metrics**: Jaccard and Cosine similarity
- **Token Frequency**: Word count and frequency analysis
- **Language Detection**: Automatic language identification
- **Sentiment Analysis**: Basic positive/negative sentiment scoring
- **Batch Processing**: Efficient processing of multiple texts

### ⚡ Performance
- **Caching System**: Optimized repeated operations
- **Efficient Algorithms**: Optimized regex patterns
- **Lazy Loading**: Memory-efficient for large datasets

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  tokenizer_moqasem: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Usage

### Basic Tokenization

```dart
import 'package:tokenizer_moqasem/tokenizer_moqasem.dart';

// Create tokenizer with default config
final tokenizer = Tokenizer();

// Tokenize text
final text = 'مرحباً بك في عالم البرمجة';
final tokens = tokenizer.tokenize(text);
print(tokens); // [مرحبا, بك, في, عالم, البرمجة]

// Get token count
print(tokenizer.countTokens(text)); // 5

// Get unique tokens
print(tokenizer.uniqueTokens(text)); // {مرحبا, بك, في, عالم, البرمجة}
```

### Custom Configuration

```dart
final config = TokenizerConfig(
  type: TokenizationType.word,
  toLowerCase: true,
  removePunctuation: true,
  removeStopWords: true,
  normalizeArabic: true,
  useFuzzyMatching: true,
  fuzzyThreshold: 0.7,
);

final tokenizer = Tokenizer(config: config);
```

### Fuzzy Matching (Typo Tolerance)

```dart
final tokenizer = Tokenizer(
  config: TokenizerConfig(
    useFuzzyMatching: true,
    fuzzyThreshold: 0.7,
  ),
);

// Compare sentences with typos
final query = 'الطالب دهب الى المدرسه'; // Contains typos
final sentences = [
  'الطالب ذهب إلى المدرسة',
  'التلميذ ذهب للمدرسة',
  'الطالب جاء من المدرسة',
];

final results = tokenizer.compareSentences(query, sentences);
for (final result in results) {
  print('${result.rank}. ${result.percentage.toStringAsFixed(2)}% - ${result.sentence}');
}
```

### Arabic Text Processing

```dart
// Normalize Arabic text
final text = 'أَلسَّلامُ عَلَيْكُمْ';
final normalized = tokenizer.normalizeArabicText(text);
print(normalized); // السلام عليكم

// Convert Arabic numbers
final arabicNum = '٠١٢٣٤٥٦٧٨٩';
final english = tokenizer.arabicToEnglishNumbers(arabicNum);
print(english); // 0123456789

// Extract numbers
final mixedText = 'لدي ٥ تفاحات و 3 برتقالات';
final numbers = tokenizer.extractNumbers(mixedText);
print(numbers); // {arabic: [٥], english: [3]}
```

### Similarity Calculation

```dart
// Word similarity
final sim = tokenizer.wordSimilarityPercentage('قال', 'دال');
print('${(sim * 100).toStringAsFixed(1)}%'); // 75.0%

// Sentence similarity (Cosine)
final sim1 = tokenizer.fuzzyCosineSimilarity(
  'I love programming',
  'I enjoy coding'
);

// Sentence similarity (Jaccard)
final sim2 = tokenizer.fuzzyJaccardSimilarity(
  'مرحباً بك',
  'مرحبا بكم'
);
```

### Language Detection

```dart
final lang1 = tokenizer.detectLanguage('Hello World');
print(lang1); // Language.english

final lang2 = tokenizer.detectLanguage('مرحباً بك');
print(lang2); // Language.arabic

final lang3 = tokenizer.detectLanguage('Hello مرحباً');
print(lang3); // Language.mixed
```

### N-Gram Tokenization

```dart
final tokenizer = Tokenizer(
  config: TokenizerConfig(
    type: TokenizationType.ngram,
    ngramSize: 2,
  ),
);

final text = 'natural language processing';
final ngrams = tokenizer.tokenize(text);
print(ngrams); // [natural language, language processing]
```

### Sentiment Analysis

```dart
final sentiment = tokenizer.analyzeSentiment('هذا رائع جداً!');
print(sentiment.score); // Positive score
print(sentiment.label); // 'positive' or 'negative' or 'neutral'
```

### Batch Processing

```dart
final texts = [
  'النص الأول',
  'النص الثاني',
  'النص الثالث',
];

final allTokens = texts.map((t) => tokenizer.tokenize(t)).toList();
final similarities = tokenizer.compareAllPairs(texts);
```

## 🎨 Advanced Examples

### Finding Similar Sentences with Word Matches

```dart
final tokenizer = Tokenizer(
  config: TokenizerConfig(useFuzzyMatching: true),
);

final query = 'وقال له اذهب';
final sentences = [
  'قال له اذهب للمدرسة',
  'و دال له اذهب',  // Typo
  'وقال لهم اذهبوا',
];

final results = tokenizer.compareSentences(
  query,
  sentences,
  showWordMatches: true,
);

for (final result in results) {
  print(result); // Shows word-by-word matches
}
```

### Custom Stop Words

```dart
final customStopWords = {'في', 'من', 'إلى', 'the', 'a', 'an'};

final tokenizer = Tokenizer(
  config: TokenizerConfig(
    removeStopWords: true,
    stopWords: customStopWords,
  ),
);
```

### Custom Regex Pattern

```dart
final tokenizer = Tokenizer(
  config: TokenizerConfig(
    type: TokenizationType.custom,
    customPattern: RegExp(r'@[\w\u0600-\u06FF]+'), // Match mentions
  ),
);

final text = 'Hello @user مرحباً @مستخدم';
final mentions = tokenizer.tokenize(text);
print(mentions); // [@user, @مستخدم]
```

## 📊 Performance Tips

1. **Use Caching**: Tokenizer automatically caches results for repeated operations
2. **Batch Processing**: Process multiple texts together for better performance
3. **Adjust Threshold**: Lower fuzzy threshold (0.6-0.7) for faster matching
4. **Disable Features**: Turn off unused features like stop words removal

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with 95% AI assistance using Claude (Anthropic)
- Special thanks to the Flutter and Dart communities
- Arabic language processing inspired by various NLP research

## 📧 Contact

- GitHub: [@Ahmed Ghaith](https://github.com/Ahmed0Ghaith)
- Email: devghaith@outlook.com

## 🌟 Support

If you find this package helpful, please give it a ⭐️ on [GitHub](https://github.com/Ahmed0Ghaith/tokenizer_moqasem)!

---

**Made with ❤️ and 🤖 AI** | © 2025 Ahmed Ghaith