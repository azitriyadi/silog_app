import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:silog_app/main.dart';

void main() {
  testWidgets('Pengujian antarmuka dan navigasi Modul 6 SiLogApp',
      (WidgetTester tester) async {
    // 1. Memuat aplikasi SiLogApp
    await tester.pumpWidget(const SiLogApp());
    await tester.pumpAndSettle();

    // 2. Verifikasi komponen AppBar dan TabBar
    expect(find.text('Daftar Pengiriman'), findsOneWidget);
    expect(find.widgetWithText(Tab, 'Semua'), findsOneWidget);
    expect(find.widgetWithText(Tab, 'Dalam Perjalanan'), findsOneWidget);
    expect(find.widgetWithText(Tab, 'Diterima'), findsOneWidget);

    // 3. Verifikasi Widget Ringkasan (Tugas Praktikum G.2)
    expect(find.text('Total Pengiriman'), findsOneWidget);
    expect(find.text('Total Nilai Barang'), findsOneWidget);
    expect(find.text('3 Paket'), findsOneWidget);

    // 4. Verifikasi Kartu Pengiriman
    expect(find.text('SLG-2026-0001'), findsOneWidget);
    expect(find.text('Sepatu Lari Pria x 10'), findsOneWidget);

    // 5. Uji Navigasi ke Layar Detail Pengiriman (Navigator.push)
    await tester.tap(find.text('SLG-2026-0001'));
    await tester.pumpAndSettle();

    // Verifikasi konten Layar Detail Pengiriman
    expect(find.text('Informasi Pengiriman'), findsOneWidget);
    expect(find.text('Rincian Barang'), findsOneWidget);
    expect(find.text('Sepatu Lari Pria'), findsOneWidget);

    // 6. Uji Navigasi Kembali ke Layar Daftar (Navigator.pop)
    await tester.scrollUntilVisible(find.text('Kembali ke Daftar'), 100);
    await tester.tap(find.text('Kembali ke Daftar'));
    await tester.pumpAndSettle();

    // Pastikan kembali ke Layar Daftar Pengiriman
    expect(find.text('Daftar Pengiriman'), findsOneWidget);
    expect(find.text('SLG-2026-0001'), findsOneWidget);
  });
}
