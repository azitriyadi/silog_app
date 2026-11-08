import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:silog_app/main.dart';

void main() {
  testWidgets('SiLogApp smoke test memverifikasi tampilan profil identitas',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SiLogApp());

    // Verifikasi judul AppBar dan heading profil
    expect(find.text('silog - Modul 1'), findsOneWidget);
    expect(find.text('Identitas diri'), findsOneWidget);
    expect(find.byIcon(Icons.local_shipping), findsOneWidget);

    // Verifikasi rincian data identitas
    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Muhammad azi Triyadi'), findsOneWidget);
    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('714240025'), findsOneWidget);
    expect(find.text('Kelas'), findsOneWidget);
    expect(find.text('2B - D4 - Teknik Informatika'), findsOneWidget);
  });
}
