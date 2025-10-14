import 'package:flutter/foundation.dart';

class ManageDeliveryViewModel extends ChangeNotifier {
  final Set<int> _disabledBranches = {};

  bool isDisabled(int index) => _disabledBranches.contains(index);

  void disableBranch(int index) {
    _disabledBranches.add(index);
    notifyListeners();
  }
}
