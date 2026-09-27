class Kiriman {
  final String nama;
  final double berat;

  Kiriman(this.nama, this.berat);
}

const double batasPaketKecil = 1.0;
const double batasPaketSedang = 5.0;

double hitungTotalBerat(List<Kiriman> daftar) {
  return daftar.fold(0, (total, kiriman) => total + kiriman.berat);
}

double hitungRataRataBerat(List<Kiriman> daftar) {
  if (daftar.isEmpty) return 0;
  return hitungTotalBerat(daftar) / daftar.length;
}

Kiriman? cariKirimanTerberat(List<Kiriman> daftar) {
  if (daftar.isEmpty) return null;
  return daftar.reduce((a, b) => a.berat >= b.berat ? a : b);
}

Kiriman? cariKirimanTeringan(List<Kiriman> daftar) {
  if (daftar.isEmpty) return null;
  return daftar.reduce((a, b) => a.berat <= b.berat ? a : b);
}

String tentukanKategori(Kiriman kiriman) {
  if (kiriman.berat <= batasPaketKecil) return 'Paket Kecil';
  if (kiriman.berat <= batasPaketSedang) return 'Paket Sedang';
  return 'Kargo';
}

Map<String, int> hitungJumlahKategori(List<Kiriman> daftar) {
  final jumlah = {'Paket Kecil': 0, 'Paket Sedang': 0, 'Kargo': 0};

  for (final kiriman in daftar) {
    jumlah[tentukanKategori(kiriman)] = jumlah[tentukanKategori(kiriman)]! + 1;
  }

  return jumlah;
}

void tampilkanHasil(List<Kiriman> daftar) {
  final terberat = cariKirimanTerberat(daftar);
  final teringan = cariKirimanTeringan(daftar);
  final jumlahKategori = hitungJumlahKategori(daftar);

  print('Total berat: ${hitungTotalBerat(daftar).toStringAsFixed(2)} kg');
  print(
    'Rata-rata berat: ${hitungRataRataBerat(daftar).toStringAsFixed(2)} kg',
  );

  if (terberat != null) {
    print('Kiriman terberat: ${terberat.nama} (${terberat.berat} kg)');
  }
  if (teringan != null) {
    print('Kiriman teringan: ${teringan.nama} (${teringan.berat} kg)');
  }

  print('Jumlah Paket Kecil: ${jumlahKategori['Paket Kecil']}');
  print('Jumlah Paket Sedang: ${jumlahKategori['Paket Sedang']}');
  print('Jumlah Kargo: ${jumlahKategori['Kargo']}');
}

void main() {
  final daftarKiriman = [
    Kiriman('Kiriman 1', 0.5),
    Kiriman('Kiriman 2', 1.0),
    Kiriman('Kiriman 3', 1.5),
    Kiriman('Kiriman 4', 2.0),
    Kiriman('Kiriman 5', 3.0),
    Kiriman('Kiriman 6', 5.0),
    Kiriman('Kiriman 7', 6.0),
    Kiriman('Kiriman 8', 10.0),
  ];

  tampilkanHasil(daftarKiriman);
}
