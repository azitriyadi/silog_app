import 'package:flutter/material.dart';
import '../data/data_contoh.dart';
import '../model/pengiriman.dart';
import '../widget/kartu_pengiriman.dart';
import '../widget/ringkasan_pengiriman.dart';
import 'detail_pengiriman_page.dart';
import 'form_pengiriman_page.dart';

class DaftarPengirimanPage extends StatefulWidget {
  const DaftarPengirimanPage({super.key});

  @override
  State<DaftarPengirimanPage> createState() => _DaftarPengirimanPageState();
}

class _DaftarPengirimanPageState extends State<DaftarPengirimanPage> {
  late List<Pengiriman> _daftar;
  String _filterStatus = 'Semua';

  @override
  void initState() {
    super.initState();
    // Inisialisasi state daftar pengiriman dari data contoh
    _daftar = List<Pengiriman>.from(dataPengiriman);
  }

  List<Pengiriman> get _hasilSaring => _filterStatus == 'Semua'
      ? _daftar
      : _daftar.where((p) => p.status == _filterStatus).toList();

  Future<void> _bukaFormulir() async {
    // Mengirim daftar resi yang ada untuk validasi duplikasi (Tugas Praktikum E.2)
    final hasil = await Navigator.push<Pengiriman>(
      context,
      MaterialPageRoute(
        builder: (_) => FormPengirimanPage(
          daftarResiAda: _daftar.map((p) => p.resi).toList(),
        ),
      ),
    );

    if (hasil != null) {
      setState(() => _daftar.insert(0, hasil));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pengiriman ${hasil.resi} berhasil ditambahkan')),
      );
    }
  }

  Future<void> _bukaDetail(Pengiriman item) async {
    // Menangkap aksi hapus dari layar detail (Tugas Praktikum E.3)
    final aksi = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPengirimanPage(pengiriman: item),
      ),
    );

    if (aksi == 'hapus') {
      setState(() {
        _daftar.removeWhere((p) => p.resi == item.resi);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pengiriman ${item.resi} berhasil dihapus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const opsi = ['Semua', 'Menunggu Pickup', 'Dalam Perjalanan', 'Diterima'];

    final totalNilai = _daftar.fold<double>(
      0,
      (total, p) => total + p.nilaiBarang,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pengiriman')),
      body: Column(
        children: [
          // Widget Ringkasan Pengiriman & Total Nilai Barang
          RingkasanPengiriman(
            jumlahPengiriman: _daftar.length,
            totalNilaiBarang: totalNilai,
          ),
          // Filter Status Horizontal dengan ChoiceChip
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: opsi.map((o) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(o),
                    selected: _filterStatus == o,
                    onSelected: (_) => setState(() => _filterStatus = o),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Menampilkan ${_hasilSaring.length} dari ${_daftar.length} data',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ),
          ),
          Expanded(
            child: _hasilSaring.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Tidak ada data pengiriman'),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _hasilSaring.length,
                    itemBuilder: (context, i) {
                      final item = _hasilSaring[i];
                      return KartuPengiriman(
                        pengiriman: item,
                        onTap: () => _bukaDetail(item),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormulir,
        icon: const Icon(Icons.add),
        label: const Text('Pengiriman Baru'),
      ),
    );
  }
}
