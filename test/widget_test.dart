import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uts/main.dart'; // Mengimpor file utama

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // Menggunakan const di sini

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget); // Memastikan angka awal adalah 0
    expect(find.text('1'), findsNothing);  // Memastikan angka 1 belum ada

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add)); // Menekan tombol tambah
    await tester.pump(); // Menerapkan perubahan UI

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing); // Memastikan angka 0 sudah hilang
    expect(find.text('1'), findsOneWidget); // Memastikan angka 1 sudah muncul
  });
}
