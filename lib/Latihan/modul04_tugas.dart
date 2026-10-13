// ignore_for_file: avoid_print

import '../model/barang.dart';
import '../model/gudang.dart';
import '../model/pelanggan.dart';
import '../model/pengiriman.dart';

void main() {
  print('=== PENGUJIAN TUGAS PRAKTIKUM MODUL 04 ===\n');

  // 1. Pengujian Entitas Pelanggan & Metode alamatRingkas()
  print('--- 1. Pengujian Kelas Pelanggan ---');
  final pelanggan1 = Pelanggan(
    kode: 'PLG-001',
    nama: 'Budi Santoso',
    nomorTelepon: '081234567890',
    alamat: 'Jl. Surya Sumantri No. 104, Sukajadi, Kota Bandung, Jawa Barat 40164', // > 40 karakter
  );

  final pelanggan2 = Pelanggan(
    kode: 'PLG-002',
    nama: 'Siti Aminah',
    nomorTelepon: '089876543210',
    alamat: 'Jl. Riau No. 12, Bandung', // <= 40 karakter
  );

  print('Pelanggan 1 (Alamat Panjang > 40 karakter):');
  print('  Alamat Asli (${pelanggan1.alamat.length} kar): ${pelanggan1.alamat}');
  print('  Alamat Ringkas (${pelanggan1.alamatRingkas().length} kar): ${pelanggan1.alamatRingkas()}');
  print('  toString(): $pelanggan1\n');

  print('Pelanggan 2 (Alamat Singkat <= 40 karakter):');
  print('  Alamat Asli (${pelanggan2.alamat.length} kar): ${pelanggan2.alamat}');
  print('  Alamat Ringkas (${pelanggan2.alamatRingkas().length} kar): ${pelanggan2.alamatRingkas()}');
  print('  toString(): $pelanggan2\n');

  // 2. Pengujian Integrasi Pelanggan pada Pengiriman
  print('--- 2. Pengujian Kelas Pengiriman dengan Pelanggan ---');
  final gudangBandung = Gudang(
    kode: 'GD-BDG',
    nama: 'Gudang Utama Bandung',
    kota: 'Bandung',
    kapasitas: 1000,
  );

  final laptop = Barang(
    kode: 'BRG-001',
    nama: 'Laptop ThinkPad T480',
    hargaSatuan: 5500000,
    beratKg: 1.6,
  );

  gudangBandung.terimaBarang(laptop, 25);
  print('Gudang: $gudangBandung');
  print('Stok Barang di Gudang: ${gudangBandung.stok}');

  // Buat pengiriman baru dengan pelanggan
  final pengiriman1 = Pengiriman.baru(
    resi: 'SLG-2026-0889',
    asal: gudangBandung,
    kotaTujuan: 'Surabaya',
    barang: laptop,
    jumlah: 2,
    pelanggan: pelanggan1,
  );

  gudangBandung.keluarkanBarang(laptop, pengiriman1.jumlah);

  print('\nInformasi Pengiriman (dengan Pelanggan):');
  print('  $pengiriman1');
  print('  Penerima: ${pengiriman1.pelanggan?.nama}');
  print('  Nomor Telepon: ${pengiriman1.pelanggan?.nomorTelepon}');
  print('  Alamat Ringkas: ${pengiriman1.pelanggan?.alamatRingkas()}');
  print('  Nilai Total Barang: Rp${pengiriman1.nilaiBarang.toStringAsFixed(0)}');
  print('  Sisa Stok di Gudang: ${gudangBandung.stok}');

  // Siklus status pengiriman
  print('\n--- 3. Pengujian Transisi Status Pengiriman ---');
  print('Status Awal: ${pengiriman1.status}');
  pengiriman1.ubahStatus('Dalam Perjalanan');
  print('Status Update: ${pengiriman1.status}');
  pengiriman1.ubahStatus('Tiba di Kota Tujuan');
  print('Status Update: ${pengiriman1.status}');
  pengiriman1.ubahStatus('Diterima');
  print('Status Akhir: ${pengiriman1.status}');
  print('Info Final: $pengiriman1');

  // Uji penolakan transisi mundur (validasi state)
  try {
    print('\nMencoba memundurkan status ke "Draft"...');
    pengiriman1.ubahStatus('Draft');
  } on StateError catch (e) {
    print('  [DITOLAK]: ${e.message}');
  }
}
