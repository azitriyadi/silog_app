// ignore_for_file: avoid_print, unnecessary_type_check

import '../layanan/layanan_pengiriman.dart';
import '../layanan/moda.dart';

void main() {
  final List<LayananPengiriman> daftarLayanan = [
    PengirimanTruk(
      kodeLayanan: 'TRK-REG',
      jarakKm: 780,
      beratKg: 1200,
    ),
    PengirimanTruk(
      kodeLayanan: 'TRK-EXP',
      jarakKm: 780,
      beratKg: 1200,
      ekspres: true,
    ),
    PengirimanKeretaApi(
      kodeLayanan: 'KA-CARGO',
      jarakKm: 780,
      beratKg: 1200,
      stasiunAsal: 'Kiaracondong',
      stasiunTujuan: 'Pasar Turi',
    ),
    PengirimanKapal(
      kodeLayanan: 'KPL-PETI',
      jarakKm: 1450,
      beratKg: 1200,
      volumeM3: 8.5,
    ),
    // Penambahan moda baru: PengirimanUdara (Bagian E & F)
    PengirimanUdara(
      kodeLayanan: 'UDR-CARGO',
      jarakKm: 780,
      beratKg: 1200,
      bandara: 'HLP - Halim Perdanakusuma',
      panjangCm: 200,
      lebarCm: 150,
      tinggiCm: 100, // volumetrik = (200*150*100)/6000 = 500 kg (< 1200 kg)
    ),
  ];

  print('=== Perbandingan Layanan Pengiriman ===');
  for (final layanan in daftarLayanan) {
    print(layanan.ringkasan());
  }

  daftarLayanan.sort((a, b) => a.hitungTarif().compareTo(b.hitungTarif()));
  print('\nLayanan termurah : ${daftarLayanan.first.kodeLayanan}');
  print(
    'Layanan tercepat : '
    '${daftarLayanan.reduce((a, b) => a.estimasiHari() <= b.estimasiHari() ? a : b).kodeLayanan}',
  );

  // Pemanfaatan mixin Terlacak
  final truk = daftarLayanan.whereType<PengirimanTruk>().first;
  truk.catatPosisi('Gudang Utama Bandung');
  truk.catatPosisi('Rest Area KM 207');
  truk.catatPosisi('Gudang Transit Semarang');
  print('\nRiwayat posisi ${truk.kodeLayanan}:');
  for (final r in truk.riwayat) {
    print('  $r');
  }
  print('Posisi terakhir: ${truk.posisiTerakhir()}');

  // Pemanfaatan mixin Terasuransi (Tugas Praktikum F)
  print('\n=== Pengujian Mixin Terasuransi (Tugas F) ===');
  const double nilaiBarang = 50000000; // Rp 50.000.000

  // 1. PengirimanKapal memiliki mixin Terasuransi
  final kapal = daftarLayanan.whereType<PengirimanKapal>().first;
  print(
    'Premi Asuransi Kapal (${kapal.kodeLayanan}, tarif premi ${(kapal.persentasePremi * 100).toStringAsFixed(2)}%): '
    'Rp${kapal.hitungPremi(nilaiBarang).toStringAsFixed(0)}',
  );

  // 2. PengirimanUdara memiliki mixin Terasuransi
  final udara = daftarLayanan.whereType<PengirimanUdara>().first;
  print(
    'Premi Asuransi Udara (${udara.kodeLayanan}, tarif premi ${(udara.persentasePremi * 100).toStringAsFixed(2)}%): '
    'Rp${udara.hitungPremi(nilaiBarang).toStringAsFixed(0)}',
  );

  // 3. Pembuktian bahwa PengirimanTruk tidak memiliki mixin Terasuransi
  print(
    'PengirimanTruk memiliki Terasuransi? ${truk is Terasuransi}',
  );
  print(
    'PengirimanKapal memiliki Terasuransi? ${kapal is Terasuransi}',
  );
  print(
    'PengirimanUdara memiliki Terasuransi? ${udara is Terasuransi}',
  );
}
