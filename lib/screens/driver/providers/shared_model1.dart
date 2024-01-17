import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class SharedBoolData extends ChangeNotifier {
  bool _isData = false;

  bool get data => _isData;

  void updateData(bool newData) {
    _isData = newData;
    notifyListeners(); // Notifies listeners about the data change
  }
}
