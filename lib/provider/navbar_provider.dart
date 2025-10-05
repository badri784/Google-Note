import 'package:flutter_riverpod/legacy.dart';

class Navbarprovider extends StateNotifier<int> {
  Navbarprovider() : super(0);

  void selectpage(int index) {
    state = index;
  }
}

final navbarnotifier = StateNotifierProvider<Navbarprovider, int>(
  (_) => Navbarprovider(),
);
