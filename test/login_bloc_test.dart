import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_app_firebase/logic/login_bloc/login_bloc.dart';
import 'package:notes_app_firebase/logic/login_bloc/login_event.dart';
import 'package:notes_app_firebase/logic/login_bloc/login_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late LoginBloc loginBloc;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    loginBloc = LoginBloc(mockFirebaseAuth);
  });

  tearDown(() {
    loginBloc.close();
  });

  blocTest<LoginBloc, LoginState>(
    'emits [Loading, Loaded] when login succeeds',
    build: () {
      when(
            () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => MockUserCredential());
      return loginBloc;
    },
    act: (bloc) =>
        bloc.add(LoginButtonPressed("test@test.com", "123456")),
    expect: () => [
      LoginStateLoading(),
      LoginStateLoaded(),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits [Loading, Error] when login fails',
    build: () {
      when(
            () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => Future.error(
        FirebaseAuthException(
          code: "user-not-found",
          message: "User not found",
        ),
      ));
      return loginBloc;
    },
    act: (bloc) =>
        bloc.add(LoginButtonPressed("wrong@test.com", "blabl")),
    expect: () => [
      LoginStateLoading(),
      LoginStateError("User not found"),
    ],
  );
}

// The test output says:
//
// ```
// Expected: [Instance of 'LoginStateLoading', Instance of 'LoginStateLoaded']
// Actual:   [Instance of 'LoginStateLoading', Instance of 'LoginStateLoaded']
// Which: at location [0] is <Instance of 'LoginStateLoading'> instead of <Instance of 'LoginStateLoading'>
// ```
//
// That looks identical, right? 😅
// But blocTest is actually telling you:
//
// > The two instances are **different objects** in memory — and your states don’t override equality.
//
// ---
//
// ## 🧠 Why this happens
//
// By default, Dart compares objects by **reference**, not content.
// So even if two states have the same fields and values,
// `LoginStateLoading() == LoginStateLoading()` → ❌ false
//
// That’s why `blocTest` warns you:
//
// > “Please ensure state instances extend Equatable, override == and hashCode, or implement Comparable.”
//
// ---
//
// ## ✅ How to fix it (recommended approach): Equatable
// ## ✅ Alternative (quick workaround)
//
// If you **don’t** want to modify your state classes right now,
// you can use *matchers* in your test instead of comparing instances directly:
//
// ```dart
// expect: () => [
// isA<LoginStateLoading>(),
// isA<LoginStateLoaded>(),
// ],
// ```
//
// Or for the failure test:
//
// ```dart
// expect: () => [
// isA<LoginStateLoading>(),
// isA<LoginStateError>(),
// ],
// ```
//
// This way, blocTest checks only the *type* of the emitted states, not equality.
//
// ---
//
// ## 🚀 Best practice summary
//
// | Approach            | Code change                              | Reliability | Notes                      |
// | ------------------- | ---------------------------------------- | ----------- | -------------------------- |
// | ✅ **Use Equatable** | Add `extends Equatable` to state classes | ⭐⭐⭐⭐        | Best long-term fix         |
// | 🟡 **Use matchers** | `isA<LoginStateLoading>()`               | ⭐⭐          | Fast, good for quick tests |
//
// ---