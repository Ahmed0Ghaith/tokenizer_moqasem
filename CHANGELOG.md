# Tokenizer Moqasem 🚀



**مكتبة ذكية لمعالجة النصوص مع دعم متقدم للغة العربية، مطابقة غامضة، وتحليل نصي مدعوم بالذكاء الاصطناعي**

> ⚡ **ملاحظة الذكاء الاصطناعي:** تم إنشاء هذه المكتبة بنسبة 95% بمساعدة الذكاء الاصطناعي ، مما يُظهر قوة أدوات التطوير الحديثة المدعومة بالذكاء الاصطناعي.

---

## ✨ المميزات

### 🔤 تقطيع نصي متقدم
- **استراتيجيات متعددة**: كلمات، جمل، أحرف، مسافات، n-gram، أنماط مخصصة
- **دعم متعدد اللغات**: العربية، الإنجليزية، والنصوص المختلطة
- **معالجة ذكية**: حذف الأحرف الصغيرة، علامات الترقيم، وكلمات التوقف القابلة للتخصيص

### 🎯 المطابقة الغامضة (Fuzzy Matching)
- **مسافة Levenshtein**: حساب المسافة التحريرية بين النصوص
- **تشابه الكلمات**: تسجيل بالنسبة المئوية
- **تحمل الأخطاء الإملائية**: إيجاد المطابقات حتى مع وجود أخطاء
- **عتبة قابلة للتخصيص**: ضبط حساسية المطابقة

### 🇸🇦 دعم متقدم للغة العربية
- **تطبيع النص**: إزالة التشكيل تلقائياً
- **تنويعات الألف**: تطبيع أ، إ، آ ← ا
- **التاء المربوطة**: معالجة ة ← ه
- **تحويل الأرقام**: الأرقام العربية (٠-٩) إلى إنجليزية (0-9)
- **المطابقة الصوتية**: تشابه صوتي للأحرف العربية
- **استخراج الجذر**: استخلاص جذور الكلمات العربية (Stemming)

### 📊 تحليل النصوص
- **مقاييس التشابه**: Jaccard و Cosine similarity
- **تكرار الكلمات**: تحليل عدد وتكرار الكلمات
- **كشف اللغة**: تحديد اللغة تلقائياً
- **تحليل المشاعر**: تسجيل المشاعر الإيجابية/السلبية
- **معالجة دفعية**: معالجة فعالة لنصوص متعددة

### ⚡ الأداء
- **نظام تخزين مؤقت**: عمليات محسّنة ومتكررة
- **خوارزميات فعالة**: أنماط regex محسّنة
- **تحميل كسول**: كفاءة في الذاكرة للمجموعات الكبيرة

---

## 📦 التثبيت

أضف هذا إلى ملف `pubspec.yaml`:

```yaml
dependencies:
  tokenizer_moqasem: ^1.0.0
```

ثم نفذ:

```bash
flutter pub get
```

---

## 🚀 الاستخدام

### التقطيع الأساسي

```dart
import 'package:tokenizer_moqasem/tokenizer_moqasem.dart';

// إنشاء tokenizer بالإعدادات الافتراضية
final tokenizer = Tokenizer();

// تقطيع النص
final text = 'مرحباً بك في عالم البرمجة';
final tokens = tokenizer.tokenize(text);
print(tokens); // [مرحبا, بك, في, عالم, البرمجة]

// عد الكلمات
print(tokenizer.countTokens(text)); // 5

// الكلمات الفريدة
print(tokenizer.uniqueTokens(text));
```

### إعدادات مخصصة

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

### المطابقة الغامضة (تحمل الأخطاء الإملائية)

```dart
final tokenizer = Tokenizer(
  config: TokenizerConfig(
    useFuzzyMatching: true,
    fuzzyThreshold: 0.7,
  ),
);

// مقارنة جمل تحتوي على أخطاء إملائية
final query = 'الطالب دهب الى المدرسه'; // يحتوي على أخطاء
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

### معالجة النصوص العربية

```dart
// تطبيع النص العربي
final text = 'أَلسَّلامُ عَلَيْكُمْ';
final normalized = tokenizer.normalizeArabicText(text);
print(normalized); // السلام عليكم

// تحويل الأرقام العربية
final arabicNum = '٠١٢٣٤٥٦٧٨٩';
final english = tokenizer.arabicToEnglishNumbers(arabicNum);
print(english); // 0123456789

// استخراج الأرقام
final mixedText = 'لدي ٥ تفاحات و 3 برتقالات';
final numbers = tokenizer.extractNumbers(mixedText);
print(numbers); // {arabic: [٥], english: [3]}
```

### حساب التشابه

```dart
// تشابه الكلمات
final sim = tokenizer.wordSimilarityPercentage('قال', 'دال');
print('${(sim * 100).toStringAsFixed(1)}%'); // 75.0%

// تشابه الجمل (Cosine)
final sim1 = tokenizer.fuzzyCosineSimilarity(
  'أحب البرمجة',
  'أستمتع بالبرمجة'
);

// تشابه الجمل (Jaccard)
final sim2 = tokenizer.fuzzyJaccardSimilarity(
  'مرحباً بك',
  'مرحبا بكم'
);
```

### كشف اللغة

```dart
final lang1 = tokenizer.detectLanguage('Hello World');
print(lang1); // Language.english

final lang2 = tokenizer.detectLanguage('مرحباً بك');
print(lang2); // Language.arabic

final lang3 = tokenizer.detectLanguage('Hello مرحباً');
print(lang3); // Language.mixed
```

### N-Gram التقطيع

```dart
final tokenizer = Tokenizer(
  config: TokenizerConfig(
    type: TokenizationType.ngram,
    ngramSize: 2,
  ),
);

final text = 'معالجة اللغة الطبيعية';
final ngrams = tokenizer.tokenize(text);
print(ngrams); // [معالجة اللغة, اللغة الطبيعية]
```

### إحصائيات النص

```dart
final stats = tokenizer.getStatistics('مرحباً بك في عالم البرمجة الجميل');
print(stats);
// إجمالي الكلمات: 6
// الكلمات الفريدة: 6
// متوسط طول الكلمة: 4.5
// التنوع اللغوي: 100%
// كلمات عربية: 6
```

### استخراج الجذور (Stemming)

```dart
final stem = ArabicStemmer.stem('المدرسة');
print(stem); // مدرس

final root = ArabicStemmer.extractRoot('كاتبون');
print(root); // كتب

// مقارنة الجذور
final same = ArabicStemmer.haveSameRoot('كتب', 'كاتب');
print(same); // true
```

### المطابقة الصوتية

```dart
// تشابه صوتي للكلمات العربية
final sim = PhoneticMatcher.calculatePhoneticSimilarity('قال', 'دال');
print('التشابه الصوتي: ${(sim * 100).toStringAsFixed(1)}%');

// البحث عن كلمات متشابهة صوتياً
final matches = PhoneticMatcher.findPhoneticMatches(
  'صالح',
  ['سالم', 'صلاح', 'فالح', 'طالح'],
  threshold: 0.6,
);
for (final match in matches) {
  print(match); // صالح ≈ صلاح (85% phonetic)
}
```

### المعالجة الدفعية

```dart
// تقطيع نصوص متعددة
final texts = [
  'النص الأول',
  'النص الثاني',
  'النص الثالث',
];

final allTokens = tokenizer.tokenizeBatch(texts);

// مقارنة جميع الأزواج (مصفوفة التشابه)
final similarities = tokenizer.compareAllPairs(texts);
```

### إعدادات محسّنة

```dart
// محسّن للعربية
final arabicTokenizer = Tokenizer(
  config: TokenizerConfig.arabicOptimized(),
);

// محسّن للإنجليزية
final englishTokenizer = Tokenizer(
  config: TokenizerConfig.englishOptimized(),
);

// مطابقة صارمة (بدون fuzzy)
final strictTokenizer = Tokenizer(
  config: TokenizerConfig.strictMatching(),
);
```

---

## 🎨 أمثلة متقدمة

### البحث عن جمل متشابهة مع تفاصيل الكلمات

```dart
final tokenizer = Tokenizer(
  config: TokenizerConfig(useFuzzyMatching: true),
);

final query = 'وقال له اذهب';
final sentences = [
  'قال له اذهب للمدرسة',
  'و دال له اذهب',  // خطأ إملائي
  'وقال لهم اذهبوا',
];

final results = tokenizer.compareSentences(
  query,
  sentences,
  showWordMatches: true, // إظهار تطابق الكلمات
);

for (final result in results) {
  print(result);
  // يعرض:
  // - الترتيب
  // - نسبة التشابه
  // - تطابق كل كلمة على حدة
}
```

### كلمات توقف مخصصة

```dart
final customStopWords = {'في', 'من', 'إلى', 'the', 'a', 'an'};

final tokenizer = Tokenizer(
  config: TokenizerConfig(
    removeStopWords: true,
    stopWords: customStopWords,
  ),
);
```

### نمط Regex مخصص

```dart
// استخراج الإشارات (@mentions)
final tokenizer = Tokenizer(
  config: TokenizerConfig(
    type: TokenizationType.custom,
    customPattern: RegExp(r'@[\w\u0600-\u06FF]+'),
  ),
);

final text = 'مرحباً @أحمد و @محمد';
final mentions = tokenizer.tokenize(text);
print(mentions); // [@أحمد, @محمد]
```

### حفظ واستيراد الإعدادات

```dart
// حفظ الإعدادات
final config = TokenizerConfig(
  type: TokenizationType.word,
  toLowerCase: true,
  fuzzyThreshold: 0.8,
);

final jsonString = config.toJsonString();
// حفظ في قاعدة بيانات أو ملف

// استيراد الإعدادات
final loadedConfig = TokenizerConfig.fromJsonString(jsonString);
final tokenizer = Tokenizer(config: loadedConfig);
```

---

## 💡 نصائح للأداء

1. **استخدم التخزين المؤقت**: يتم التخزين المؤقت تلقائياً للعمليات المتكررة
2. **المعالجة الدفعية**: عالج نصوص متعددة معاً للأداء الأفضل
3. **ضبط العتبة**: عتبة أقل (0.6-0.7) للمطابقة الأسرع
4. **تعطيل الميزات**: أوقف الميزات غير المستخدمة مثل حذف كلمات التوقف

---

## 🤝 المساهمة

المساهمات مرحب بها! لا تتردد في إرسال Pull Request.

## 📄 الترخيص

هذا المشروع مرخص بموجب MIT License - انظر ملف [LICENSE](LICENSE) للتفاصيل.

## 🙏 شكر وتقدير

- تم البناء بنسبة 95% بمساعدة الذكاء الاصطناعي باستخدام Claude (Anthropic)
- شكر خاص لمجتمعات Flutter و Dart
- معالجة اللغة العربية مستوحاة من أبحاث مختلفة في NLP

## 📧 التواصل

- GitHub: [@Ahmed Ghaith](https://github.com/Ahmed0Ghaith)
- Email: devghaith@outlook.com

## 🌟 الدعم

إذا وجدت هذه الحزمة مفيدة، من فضلك أعطها ⭐️ على [GitHub](https://github.com/Ahmed0Ghaith/tokenizer_moqasem)!

---

**صُنع بـ ❤️ و 🤖 AI** | © 2025 Ahmed Ghaith

---

## 📚 أمثلة إضافية

### مثال كامل: تطبيق بحث ذكي

```dart
class SmartSearch {
  final tokenizer = Tokenizer(
    config: TokenizerConfig(
      useFuzzyMatching: true,
      fuzzyThreshold: 0.7,
      normalizeArabic: true,
    ),
  );

  List<String> database = [
    'كتاب البرمجة بلغة Dart',
    'تعلم Flutter للمبتدئين',
    'دليل تطوير تطبيقات الهاتف',
    'برمجة تطبيقات الويب',
  ];

  List<SimilarityResult> search(String query) {
    return tokenizer.compareSentences(query, database);
  }
}

// الاستخدام
void main() {
  final search = SmartSearch();
  final results = search.search('كتب برمجه فلاتر'); // مع أخطاء إملائية
  
  for (final result in results) {
    if (result.percentage > 50) {
      print('✓ ${result.sentence} - ${result.percentage.toStringAsFixed(1)}%');
    }
  }
}
```

### مثال: تحليل تغريدات

```dart
class TweetAnalyzer {
  final tokenizer = Tokenizer();

  Map<String, dynamic> analyze(String tweet) {
    return {
      'tokens': tokenizer.countTokens(tweet),
      'language': tokenizer.detectLanguage(tweet).name,
      'hashtags': _extractHashtags(tweet),
      'mentions': _extractMentions(tweet),
    };
  }

  List<String> _extractHashtags(String text) {
    final pattern = RegExp(r'#[\w\u0600-\u06FF]+');
    return pattern.allMatches(text).map((m) => m.group(0)!).toList();
  }

  List<String> _extractMentions(String text) {
    final pattern = RegExp(r'@[\w\u0600-\u06FF]+');
    return pattern.allMatches(text).map((m) => m.group(0)!).toList();
  }
}
