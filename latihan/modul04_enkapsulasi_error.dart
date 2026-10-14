// File ini dibuat untuk mendemonstrasikan pelanggaran enkapsulasi (Langkah E.3)
// Percobaan mengakses atribut privat _stok secara langsung dari luar library.

import '../lib/model/gudang.dart';

void main() {
  final gudangBandung = Gudang(
    kode: 'GD-BDG',
    nama: 'Gudang Utama Bandung',
    kota: 'Bandung',
    kapasitas: 500,
  );

  // Percobaan mengakses atribut privat _stok secara langsung dari main()
  // Ini akan menghasilkan error saat kompilasi:
  gudangBandung._stok['B-1024'] = 999;
}
