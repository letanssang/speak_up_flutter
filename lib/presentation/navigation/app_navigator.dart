import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppNavigatorStackAction {
  //keep all screens in stack
  keep,
  // replace the last screen in stack
  replace,
  // remove all screens in stack
  removeAll
}

// [AppNavigator] is a navigator that can be used to navigate between screens.
class AppNavigator {
  AppNavigator(this._ref);
  final Ref _ref;
  final navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(
    String routeName, {
    dynamic arguments,
    bool shouldClearStack = false,
  }) async {
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      return false;
    }

    if (shouldClearStack) {
      /// Push the route with the given name onto the navigator, and then remove
      /// all the previous routes until the `predicate` returns true.
      ///
      return currentState.pushNamedAndRemoveUntil(
        routeName,
        (route) => false,
        arguments: arguments,
      );
    }

    /// Push a named route onto the navigator.
    ///
    return currentState.pushNamed(
      routeName,
      arguments: arguments,
    );
  }
  void pop(){
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      return;
    }
    currentState.pop();
  }
}
