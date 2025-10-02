import 'dart:io';
import 'package:tokenizer_moqasem/tokenizer_moqasem.dart';

void main() {
  print('╔════════════════════════════════════════════════╗');
  print('║     Tokenizer Moqasem CLI Demo                 ║');
  print('║     🤖 Built with 95% AI Assistance            ║');
  print('╚════════════════════════════════════════════════╝\n');

  final tokenizer = Tokenizer(
    config: TokenizerConfig(
      useFuzzyMatching: true,
      fuzzyThreshold: 0.7,
      normalizeArabic: true,
    ),
  );

  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│ Main Menu:                          │');
    print('│ 1. Analyze Text                     │');
    print('│ 2. Compare Texts (Fuzzy Matching)  │');
    print('│ 3. Exit                             │');
    print('└─────────────────────────────────────┘');
    stdout.write('Choose an option: '); 

    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        analyzeText(tokenizer);
        break;
      case '2':
        compareTexts(tokenizer);
        break;
      case '3':
        print('\n👋 Goodbye!');
        return;
      default:
        print('❌ Invalid option. Please try again.');
    }
  }
}

void analyzeText(Tokenizer tokenizer) {
  print('\n┌─────────────────────────────────────┐');
  print('│ Text Analysis                       │');
  print('└─────────────────────────────────────┘');
  print('Enter text (English or Arabic):');
  print('Example: مرحباً بك في عالم البرمجة');
  print('Or: I love programming\n');

  final text = stdin.readLineSync();

  if (text == null || text.isEmpty) {
    print('❌ No text entered.');
    return;
  }


  // Tokenization
  final tokens = tokenizer.tokenize(text);
  print('\n📊 ═══ TOKENS ═══');
  print('Count: ${tokens.length}');
  print('Tokens: ${tokens.join(', ')}');

  // Language Detection
  final language = tokenizer.detectLanguage(text).name;
  print('\n🌍 ═══ LANGUAGE ═══');
  print('Detected: ${language.toUpperCase()}');

  // Word Frequency
  final frequency = tokenizer.tokenFrequency(text);
  print('\n📈 ═══ WORD FREQUENCY (Top 10) ═══');
  final sortedFreq = frequency.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  for (var i = 0; i < sortedFreq.length && i < 10; i++) {
    final entry = sortedFreq[i];
    print('${i + 1}. "${entry.key}" → ${entry.value} times');
  }
}


void compareTexts(Tokenizer tokenizer) {
  print('\n┌─────────────────────────────────────┐');
  print('│ Text Comparison (Fuzzy Matching)   │');
  print('└─────────────────────────────────────┘');

  print('Enter query text:');
  final query = stdin.readLineSync();

  if (query == null || query.isEmpty) {
    print('❌ No query entered.');
    return;
  }

  print('\nEnter sentences to compare (one per line):');
  print('Example:');
  print('  مرحباً بك');
  print('  مرحبا بكم');
  print('  أهلاً وسهلاً');
  print('\nEnter an empty line when done.\n');

  final sentences = <String>[];
  while (true) {
    final line = stdin.readLineSync();
    if (line == null || line.isEmpty) break;
    sentences.add(line);
  }

  if (sentences.isEmpty) {
    print('❌ No sentences entered.');
    return;
  }

  final similarities = tokenizer.compareSentences(
    query,
    sentences,
    showWordMatches: true,
  );

  print('\n🔍 ═══ SIMILARITY RESULTS ═══');
  print('Query: "$query"\n');

  for (final result in similarities) {
    String indicator;
    if (result.isStrongMatch) {
      indicator = '🟢 STRONG';
    } else if (result.isModerateMatch) {
      indicator = '🟡 MODERATE';
    } else {
      indicator = '🔴 WEAK';
    }

    print('─────────────────────────────────────');
    print('Rank #${result.rank} $indicator');
    print('Sentence: "${result.sentence}"');
    print('Similarity: ${result.percentage.toStringAsFixed(2)}%');

    if (result.wordMatches.isNotEmpty) {
      print('Matched words: ${result.wordMatches.length}');
      print(
        'Matches: ${result.wordMatches.map((m) => '"${m.word1}"').join(', ')}',
      );
    }
  }
  print('─────────────────────────────────────');
}

