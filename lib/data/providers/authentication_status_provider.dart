import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/authentication/is_signed_in_use_case.dart';
import 'package:speak_up/injection/injector.dart';

final authenticationStatusProvider =
    StateProvider<bool>((ref) => injector.get<IsSignedInUseCase>().run());
