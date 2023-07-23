import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/presentation/navigation/app_navigator.dart';

final appNavigatorProvider = Provider<AppNavigator>((ref) {
  return AppNavigator();
});
