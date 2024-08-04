import 'package:flutter_riverpod/flutter_riverpod.dart';

final fabVisibleProvider =
    StateNotifierProvider.autoDispose((ref) => FabVisible());

class FabVisible extends StateNotifier {
  FabVisible() : super(true);

  void hide() {
    state ? state = false : ();
  }

  void show() {
    state ? () : state = true;
  }
}
