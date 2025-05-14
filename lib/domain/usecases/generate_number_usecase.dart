import '../../utils/random_generator.dart';

class GenerateNumberUseCase {
  Map<String, dynamic> execute() {
    return RandomGenerator.generateNumberAndQuote();
  }
}
