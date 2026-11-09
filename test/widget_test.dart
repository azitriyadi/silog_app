import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:silog_app/main.dart';

void main() {
  testWidgets('Pengujian antarmuka, validasi form, dan pengelolaan state Modul 7',
      (WidgetTester tester) async {
    // 1. Memuat aplikasi SiLogApp
    await tester.pumpWidget(const SiLogApp());
    await tester.pumpAndSettle();

    // 2. Verifikasi tampilan awal Layar Daftar Pengiriman
    expect(find.text('Daftar Pengiriman'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Semua'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Menunggu Pickup'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Dalam Perjalanan'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Diterima'), findsOneWidget);
    expect(find.text('SLG-2026-0001'), findsOneWidget);

    // 3. Uji filter ChoiceChip: klik 'Dalam Perjalanan'
    await tester.tap(find.widgetWithText(ChoiceChip, 'Dalam Perjalanan'));
    await tester.pumpAndSettle();
    expect(find.text('Menampilkan 1 dari 3 data'), findsOneWidget);
    expect(find.text('SLG-2026-0001'), findsOneWidget);

    // Kembalikan ke filter 'Semua'
    await tester.tap(find.widgetWithText(ChoiceChip, 'Semua'));
    await tester.pumpAndSettle();
    expect(find.text('Menampilkan 3 dari 3 data'), findsOneWidget);

    // 4. Buka Formulir Pengiriman Baru
    await tester.tap(find.text('Pengiriman Baru'));
    await tester.pumpAndSettle();
    expect(find.text('Pengiriman Baru'), findsWidgets);

    // 5. Uji Validasi: Tekan simpan dengan form kosong
    await tester.tap(find.text('Simpan Pengiriman'));
    await tester.pumpAndSettle();
    expect(find.text('Nomor resi wajib diisi'), findsOneWidget);
    expect(find.text('Nama barang wajib diisi'), findsOneWidget);
    expect(find.text('Harga satuan wajib diisi'), findsOneWidget);
    expect(find.text('Jumlah wajib diisi'), findsOneWidget);
    expect(find.text('Berat barang wajib diisi'), findsOneWidget);

    // 6. Uji Validasi Format Resi Keliru
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nomor Resi'), 'ABC-123');
    await tester.pumpAndSettle();
    expect(find.textContaining('Format resi harus SLG-TAHUN-NOMOR'), findsOneWidget);

    // 7. Uji Validasi Resi Duplikat (Tugas Praktikum E.2)
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nomor Resi'), 'SLG-2026-0001');
    await tester.pumpAndSettle();
    expect(
        find.textContaining('sudah ada pada daftar dan tidak dapat dipakai ulang'),
        findsOneWidget);

    // 8. Uji Validasi Berat Barang di luar batas (Tugas Praktikum E.1)
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Berat Barang (kg)'), '0.05');
    await tester.pumpAndSettle();
    expect(find.text('Berat barang harus antara 0,1 dan 5000 kg'), findsOneWidget);

    // 9. Isi form dengan data valid
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nomor Resi'), 'SLG-2026-0099');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama Barang'), 'Kamera Mirrorless');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Harga Satuan (Rp)'), '8500000');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Jumlah'), '2');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Berat Barang (kg)'), '1.8');
    await tester.pumpAndSettle();

    // Simpan formulir
    await tester.tap(find.text('Simpan Pengiriman'));
    await tester.pumpAndSettle();

    // Pastikan data baru muncul di daftar paling atas
    expect(find.text('SLG-2026-0099'), findsOneWidget);
    expect(find.text('Kamera Mirrorless x 2'), findsOneWidget);
    expect(find.text('Menampilkan 4 dari 4 data'), findsOneWidget);

    // 10. Uji Hapus Pengiriman dari Layar Detail (Tugas Praktikum E.3)
    await tester.tap(find.text('SLG-2026-0099'));
    await tester.pumpAndSettle();

    // Verifikasi layar detail memuat rincian dan berat barang
    expect(find.text('Informasi Pengiriman'), findsOneWidget);
    expect(find.text('1.8 kg'), findsOneWidget);

    // Tekan tombol Hapus Pengiriman pada AppBar
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    // Konfirmasi dialog hapus muncul
    expect(find.text('Konfirmasi Hapus'), findsOneWidget);
    expect(find.textContaining('Apakah Anda yakin ingin menghapus data pengiriman'), findsOneWidget);

    // Tekan Hapus pada AlertDialog
    await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
    await tester.pumpAndSettle();

    // Verifikasi data telah terhapus dari daftar
    expect(find.text('SLG-2026-0099'), findsNothing);
    expect(find.text('Menampilkan 3 dari 3 data'), findsOneWidget);
  });
}
