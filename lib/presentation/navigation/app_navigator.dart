import 'package:flutter/widgets.dart';

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
  AppNavigator();

  final navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(
    String routeName, {
    dynamic arguments,
    bool shouldClearStack = false,
    bool shouldReplace = false,
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

    if (shouldReplace) {
      /// Push the route with the given name onto the navigator, and then remove
      /// all the previous routes until the `predicate` returns true.
      ///
      return currentState.pushReplacementNamed(
        routeName,
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

  void pop() {
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      return;
    }
    currentState.pop();
  }

  bool canGoBack() {
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      return false;
    }
    return currentState.canPop();
  }
}
