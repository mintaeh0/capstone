import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationIndexProvider =
    StateNotifierProvider((ref) => NavigationIndex());

class NavigationIndex extends StateNotifier {
  NavigationIndex() : super(0);

  void setIndex(int value) {
    state = value;
  }
}
