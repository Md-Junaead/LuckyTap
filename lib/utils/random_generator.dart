import 'dart:math';
import 'quote_generator.dart';

class RandomGenerator {
  static final Random _random = Random();

  static Map<String, dynamic> generateNumberAndQuote() {
    int number;
    if (_random.nextInt(1000) == 0) {
      number = 900 + _random.nextInt(100); // 900–999
    } else {
      number = 1 + _random.nextInt(100); // 1–100
    }
    String quote = QuoteGenerator.getRandomQuote();
    return {'number': number, 'quote': quote};
  }
}
