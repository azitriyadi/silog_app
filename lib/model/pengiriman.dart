import 'barang.dart';
import 'gudang.dart';
import 'pelanggan.dart';

class Pengiriman {
  final String resi;
  final Gudang asal;
  final String kotaTujuan;
  final Barang barang;
  final int jumlah;
  final Pelanggan? pelanggan;
  String _status;

  static const List<String> _urutanStatus = [
    'Draft',
    'Dalam Perjalanan',
    'Tiba di Kota Tujuan',
    'Diterima',
  ];

  Pengiriman({
    required this.resi,
    required this.asal,
    required this.kotaTujuan,
    required this.barang,
    required this.jumlah,
    this.pelanggan,
    String status = 'Draft',
  }) : _status = status;

  /// Konstruktor bernama untuk membuat pengiriman baru dengan status awal 'Draft'.
  Pengiriman.baru({
    required this.resi,
    required this.asal,
    required this.kotaTujuan,
    required this.barang,
    required this.jumlah,
    this.pelanggan,
  }) : _status = 'Draft';

  String get status => _status;

  double get nilaiBarang => barang.nilaiTotal(jumlah);

  void ubahStatus(String statusBaru) {
    final indeksSekarang = _urutanStatus.indexOf(_status);
    final indeksBaru = _urutanStatus.indexOf(statusBaru);

    if (indeksBaru == -1) {
      throw ArgumentError('Status "$statusBaru" tidak dikenali');
    }

    if (indeksBaru <= indeksSekarang) {
      throw StateError(
        'Tidak dapat mengubah status dari "$_status" ke "$statusBaru"',
      );
    }

    _status = statusBaru;
  }

  @override
  String toString() {
    final penerima = pelanggan != null ? ' -> ${pelanggan!.nama}' : '';
    return '$resi [$_status] ${asal.kota} ke $kotaTujuan | ${barang.nama} ($jumlah)$penerima';
  }
}
