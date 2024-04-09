import 'dart:math';
import 'package:collection/collection.dart';

class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

List<PricePoint> get pricePoints {
  final Random random = Random();
  var randomNumbers = <double>[];
  for (var i = 0; i <= 11; i++) {
    randomNumbers.add(random.nextDouble()*100);
  }
  // randomNumbers = [3,5,7,2,6,8,2,6,10];

  return randomNumbers
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element))
      .toList();
}