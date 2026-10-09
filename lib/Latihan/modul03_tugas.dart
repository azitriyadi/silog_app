// ignore_for_file: avoid_print

// Modul 03: Tugas Praktikum
// Pemrograman IV - D4 Teknik Informatika ULBI

class ResiTidakDitemukan implements Exception {
  final String resi;
  ResiTidakDitemukan(this.resi);

  @override
  String toString() => 'Resi $resi tidak terdaftar dalam sistem.';
}

// 1. Basis data status kiriman dengan Map minimal lima resi
final Map<String, String> basisDataStatus = {
  'SLG-001': 'Paket sedang disortir di Hub Logistik Bandung',
  'SLG-002': 'Paket dalam perjalanan menuju Gudang Transit Surabaya',
  'SLG-003': 'Paket tiba di Fasilitas Logistik Jakarta',
  'SLG-004': 'Paket sedang diantar oleh kurir ke alamat tujuan di Semarang',
  'SLG-005': 'Paket telah berhasil diterima oleh penerima di Yogyakarta',
};

// 1. Kembangkan fungsi ambilStatusKiriman sehingga membaca data dari sebuah Map
// berisi minimal lima resi, dan melemparkan ResiTidakDitemukan apabila resi tidak terdaftar.
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

// 2. Susun fungsi pantauBanyakResi(List<String> daftarResi) yang memanggil
// fungsi tersebut untuk seluruh resi secara bersamaan, menampilkan hasil yang berhasil,
// dan mencatat resi yang gagal tanpa menghentikan proses.
Future<void> pantauBanyakResi(List<String> daftarResi) async {
  print('Memulai pemantauan ${daftarResi.length} resi secara bersamaan...');
  final mulai = DateTime.now();

  // Eksekusi asinkron secara bersamaan menggunakan Future.wait
  // Exception ditangani per-elemen agar proses tidak dihentikan secara prematur
  final futureTasks = daftarResi.map((resi) async {
    try {
      final status = await ambilStatusKiriman(resi);
      return HasilPelacakan.sukses(resi, status);
    } on ResiTidakDitemukan catch (e) {
      return HasilPelacakan.gagal(resi, e.toString());
    } catch (e) {
      return HasilPelacakan.gagal(resi, 'Kesalahan: $e');
    }
  });

  final hasilList = await Future.wait(futureTasks);
  final durasi = DateTime.now().difference(mulai);

  final berhasil = hasilList.where((h) => h.berhasil).toList();
  final gagal = hasilList.where((h) => !h.berhasil).toList();

  print('============================================================');
  print('HASIL PEMANTAUAN RESI (Waktu Pemrosesan: ${durasi.inMilliseconds} ms):');
  print('============================================================');
  print('1. Resi Berhasil Ditemukan (${berhasil.length}):');
  if (berhasil.isEmpty) {
    print('   (Tidak ada)');
  } else {
    for (final item in berhasil) {
      print('   [OK] Resi ${item.resi}: ${item.status}');
    }
  }

  print('\n2. Resi Gagal / Tidak Ditemukan (${gagal.length}):');
  if (gagal.isEmpty) {
    print('   (Tidak ada - Seluruh resi sah)');
  } else {
    for (final item in gagal) {
      print('   [FAIL] Resi ${item.resi}: ${item.error}');
    }
  }
  print('============================================================\n');
}

// 3. Skenario seluruh resi sah dan skenario terdapat resi tidak sah.
Future<void> main() async {
  print('======================================================');
  print('TUGAS PRAKTIKUM MODUL 03: PEMROGRAMAN ASINKRON & FUTURE');
  print('======================================================\n');

  print('--- SKENARIO 1: SELURUH RESI SAH ---');
  final daftarResiSah = [
    'SLG-001',
    'SLG-002',
    'SLG-003',
    'SLG-004',
    'SLG-005',
  ];
  await pantauBanyakResi(daftarResiSah);

  print('--- SKENARIO 2: TERDAPAT RESI TIDAK SAH (TIDAK TERDAFTAR) ---');
  final daftarResiCampur = [
    'SLG-001',
    'SLG-999', // Resi tidak ada di basis data
    'SLG-003',
    'SLG-888', // Resi tidak ada di basis data
    'SLG-005',
  ];
  await pantauBanyakResi(daftarResiCampur);
}
