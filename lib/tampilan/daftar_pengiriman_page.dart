import 'package:flutter/material.dart';
import '../data/data_contoh.dart';
import '../model/pengiriman.dart';
import '../widget/kartu_pengiriman.dart';
import '../widget/ringkasan_pengiriman.dart';
import 'detail_pengiriman_page.dart';

class DaftarPengirimanPage extends StatelessWidget {
  const DaftarPengirimanPage({super.key});

  Widget _buildDaftar(BuildContext context, List<Pengiriman> daftar) {
    if (daftar.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Tidak ada data pengiriman.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: daftar.length,
      itemBuilder: (context, index) {
        final item = daftar[index];
        return KartuPengiriman(
          pengiriman: item,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPengirimanPage(pengiriman: item),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final daftarSemua = dataPengiriman;
    final daftarDalamPerjalanan =
        dataPengiriman.where((p) => p.status == 'Dalam Perjalanan').toList();
    final daftarDiterima =
        dataPengiriman.where((p) => p.status == 'Diterima').toList();

    final totalNilai = dataPengiriman.fold<double>(
      0,
      (total, p) => total + p.nilaiBarang,
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Pengiriman'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              tooltip: 'Cari resi',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Dalam Perjalanan'),
              Tab(text: 'Diterima'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Widget ringkasan pengiriman dan total nilai barang (Tugas Praktikum G.2)
            RingkasanPengiriman(
              jumlahPengiriman: dataPengiriman.length,
              totalNilaiBarang: totalNilai,
            ),
            // Tampilan daftar terfilter berdasarkan Tab yang dipilih (Tugas Praktikum G.1)
            Expanded(
              child: TabBarView(
                children: [
                  _buildDaftar(context, daftarSemua),
                  _buildDaftar(context, daftarDalamPerjalanan),
                  _buildDaftar(context, daftarDiterima),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Pengiriman Baru'),
        ),
      ),
    );
  }
}
