import 'package:logixx/models/stock.dart';

class TheBatch {
// la ahun endiw yikemet
  TheBatch({
    required this.name,
    this.stocks,
  });

  final String name;
  List<Stock>? stocks = [];

  factory TheBatch.fromMap(Map<String, dynamic> map) {
   
    return TheBatch(
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
