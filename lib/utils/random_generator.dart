// import 'dart:math';

// class RandomGenerator {
//   static final Random _random = Random();

//   static int generateNumber() {
//     // 1/1000 chance for bonus number (900–999)
//     if (_random.nextInt(1000) == 0) {
//       return 900 + _random.nextInt(100); // 900–999
//     }
//     // Otherwise, normal number (1–100)
//     return 1 + _random.nextInt(100); // 1–100
//   }
// }

import 'dart:math';
import 'quote_generator.dart';

class RandomGenerator {
  static final Random _random = Random();

  static Map<String, dynamic> generateNumberAndQuote() {
    int number;
    // 1/1000 chance for bonus number (900–999)
    if (_random.nextInt(1000) == 0) {
      number = 900 + _random.nextInt(100); // 900–999
    } else {
      number = 1 + _random.nextInt(100); // 1–100
    }
    // Get a random positive quote
    String quote = QuoteGenerator.getRandomQuote();
    return {'number': number, 'quote': quote};
  }
}
