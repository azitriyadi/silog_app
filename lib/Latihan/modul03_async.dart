// ignore_for_file: avoid_print

// Modul 03: Pemrograman Asinkron dan Future
// Praktikum Pemrograman IV - D4 Teknik Informatika ULBI

// ==========================================
// Latihan 3 & 4: Future, Async, Await & Parallel Future.wait
// ==========================================

Future<String> simulasiStatusKiriman(String resi) async {
  // Simulasi jeda jaringan selama dua detik
  await Future.delayed(const Duration(seconds: 2));

  if (!resi.startsWith('SLG-')) {
    throw FormatException('Format resi tidak sah: $resi');
  }
  return 'Paket $resi sedang dalam perjalanan menuju gudang transit.';
}

Future<double> ambilOngkir(String resi) async {
  // Simulasi jeda jaringan selama satu detik
  await Future.delayed(const Duration(seconds: 1));
  return 105400;
}

Future<void> ujiLatihan3() async {
  print('--- Latihan 3: Pengambilan Data Berurutan ---');
  print('1. Permintaan data dikirim...');
  try {
    final status = await simulasiStatusKiriman('SLG-002');
    print('2. $status');
    final ongkir = await ambilOngkir('SLG-002');
    print('3. Ongkos kirim: Rp${ongkir.toStringAsFixed(0)}');
  } on FormatException catch (e) {
    print('Kesalahan format: ${e.message}');
  } catch (e) {
    print('Gagal mengambil data: $e');
  }
  print('4. Proses selesai.');
}

Future<void> bandingkanWaktu() async {
  print('\n--- Latihan 4: Eksekusi Paralel dengan Future.wait ---');
  final mulai = DateTime.now();
  final hasil = await Future.wait([
    simulasiStatusKiriman('SLG-001'),
    ambilOngkir('SLG-001'),
  ]);
  final durasi = DateTime.now().difference(mulai);
  print('Status : ${hasil[0]}');
  print('Ongkir : Rp${(hasil[1] as double).toStringAsFixed(0)}');
  print('Durasi total: ${durasi.inMilliseconds} ms');
}

// ==========================================
// F. Tugas Praktikum
// ==========================================

class ResiTidakDitemukan implements Exception {
  final String resi;
  ResiTidakDitemukan(this.resi);

  @override
  String toString() => 'Resi $resi tidak terdaftar dalam sistem.';
}

// Basis data status kiriman dengan minimal 5 resi
final Map<String, String> basisDataStatus = {
  'SLG-001': 'Paket sedang disortir di Hub Logistik Bandung',
  'SLG-002': 'Paket dalam perjalanan menuju Gudang Transit Surabaya',
  'SLG-003': 'Paket tiba di Fasilitas Logistik Jakarta',
  'SLG-004': 'Paket sedang diantar oleh kurir ke alamat tujuan di Semarang',
  'SLG-005': 'Paket telah berhasil diterima oleh penerima di Yogyakarta',
};

// Fungsi yang membaca status resi dari Map secara asinkron
// Melemparkan ResiTidakDitemukan bila resi tidak terdaftar
Future<String> ambilStatusKiriman(String resi) async {
  // Simulasi jeda I/O atau jaringan
  await Future.delayed(const Duration(milliseconds: 500));

  final status = basisDataStatus[resi];
  if (status == null) {
    throw ResiTidakDitemukan(resi);
  }
  return status;
}

// Model hasil pelacakan resi
class HasilPelacakan {
  final String resi;
  final String? status;
  final String? error;
  final bool berhasil;

  HasilPelacakan.sukses(this.resi, this.status)
      : berhasil = true,
        error = null;

  HasilPelacakan.gagal(this.resi, this.error)
      : berhasil = false,
        status = null;
}

// Fungsi memantau banyak resi secara bersamaan (paralel)
// Menampilkan yang berhasil dan mencatat yang gagal tanpa menghentikan proses
Future<void> pantauBanyakResi(List<String> daftarResi) async {
  print('Memulai pemantauan ${daftarResi.length} resi secara bersamaan...');
  final mulai = DateTime.now();

  // Memanggil seluruh resi secara paralel dengan Future.wait
  // Masing-masing Future menangani error secara mandiri agar tidak menghentikan yang lain
  final listFutures = daftarResi.map((resi) async {
    try {
      final status = await ambilStatusKiriman(resi);
      return HasilPelacakan.sukses(resi, status);
    } on ResiTidakDitemukan catch (e) {
      return HasilPelacakan.gagal(resi, e.toString());
    } catch (e) {
      return HasilPelacakan.gagal(resi, 'Terjadi kesalahan tidak terduga: $e');
    }
  });

  final hasilList = await Future.wait(listFutures);
  final durasi = DateTime.now().difference(mulai);

  final berhasil = hasilList.where((h) => h.berhasil).toList();
  final gagal = hasilList.where((h) => !h.berhasil).toList();

  print('------------------------------------------------------------');
  print('HASIL PEMANTAUAN RESI (Waktu eksekusi: ${durasi.inMilliseconds} ms):');
  print('------------------------------------------------------------');
  print('1. Resi Berhasil Ditemukan (${berhasil.length}):');
  if (berhasil.isEmpty) {
    print('   (Tidak ada resi yang berhasil dipantau)');
  } else {
    for (final item in berhasil) {
      print('   [OK] Resi ${item.resi}: ${item.status}');
    }
  }

  print('\n2. Resi Gagal / Bermasalah (${gagal.length}):');
  if (gagal.isEmpty) {
    print('   (Semua resi berhasil ditemukan, tidak ada kegagalan)');
  } else {
    for (final item in gagal) {
      print('   [FAIL] Resi ${item.resi}: ${item.error}');
    }
  }
  print('------------------------------------------------------------');
}

// ==========================================
// Main Function
// ==========================================

Future<void> main() async {
  print('=== MODUL 03 - LATIHAN 3: ASYNC & AWAIT ===');
  await ujiLatihan3();

  print('\n=== MODUL 03 - LATIHAN 4: PARALEL FUTURE.WAIT ===');
  await bandingkanWaktu();

  print('\n============================================================');
  print('=== F. TUGAS PRAKTIKUM: PANTAU BANYAK RESI SECARA BERSAMAAN ===');
  print('============================================================');

  print('\n--- SKENARIO 1: SELURUH RESI SAH ---');
  final resiSah = ['SLG-001', 'SLG-002', 'SLG-003', 'SLG-004', 'SLG-005'];
  await pantauBanyakResi(resiSah);

  print('\n--- SKENARIO 2: TERDAPAT RESI TIDAK SAH / TIDAK TERDAFTAR ---');
  final resiCampur = [
    'SLG-001',
    'SLG-999', // tidak terdaftar
    'SLG-003',
    'SLG-888', // tidak terdaftar
    'SLG-005',
  ];
  await pantauBanyakResi(resiCampur);
}
