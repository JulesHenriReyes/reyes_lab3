import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reyes_lab3/main.dart';

void main() {
  Future<void> enter(WidgetTester t, String label, String text) async {
    await t.enterText(find.widgetWithText(TextFormField, label), text);
  }

  testWidgets('register, validate, login and logout', (tester) async {
    await tester.pumpWidget(const AuthApp());

    // Login before registering.
    await enter(tester, 'Email', 'juan@example.com');
    await enter(tester, 'Password', 'flutter123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();
    expect(find.text('Please register an account first.'), findsOneWidget);

    // Switch to registration; empty submit shows required errors.
    await tester.tap(find.text('No account yet? Register'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pump();
    expect(find.text('Please enter your full name.'), findsOneWidget);
    expect(find.text('Please enter your email.'), findsOneWidget);

    // Short password (8-char minimum) and mismatch.
    await enter(tester, 'Full Name', 'Juan Dela Cruz');
    await enter(tester, 'Email', 'juan');
    await enter(tester, 'Password', 'short12');
    await enter(tester, 'Confirm Password', 'different1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pump();
    expect(find.text('Please enter a valid email.'), findsOneWidget);
    expect(find.text('Use at least 8 characters.'), findsOneWidget);
    expect(find.text('Passwords do not match.'), findsOneWidget);

    // Valid registration.
    await enter(tester, 'Email', 'juan@example.com');
    await enter(tester, 'Password', 'flutter123');
    await enter(tester, 'Confirm Password', 'flutter123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pump();
    expect(find.text('Registration successful! Please log in.'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    // Wrong password.
    await enter(tester, 'Email', 'juan@example.com');
    await enter(tester, 'Password', 'wrongpass1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();
    expect(find.text('Incorrect email or password.'), findsOneWidget);

    // Correct login, then logout.
    await enter(tester, 'Password', 'flutter123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, Juan Dela Cruz!'), findsOneWidget);
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });
}
