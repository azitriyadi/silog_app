class Pelanggan {
  final String kode;
  final String nama;
  final String nomorTelepon;
  final String alamat;

  Pelanggan({
    required this.kode,
    required this.nama,
    required this.nomorTelepon,
    required this.alamat,
  });

  /// Mengembalikan ringkasan alamat.
  /// Jika panjang alamat lebih dari 40 karakter, dipotong hingga 40 karakter pertama dan diberi '...'.
  String alamatRingkas() {
    if (alamat.length > 40) {
      return '${alamat.substring(0, 40)}...';
    }
    return alamat;
  }

  @override
  String toString() => '$kode - $nama ($nomorTelepon)';
}
