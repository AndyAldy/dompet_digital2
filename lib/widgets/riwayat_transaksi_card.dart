import 'package:flutter/material.dart';

class RiwayatTransaksiCard extends StatelessWidget {
  final List<Map<String, dynamic>> riwayatTransaksi;

  const RiwayatTransaksiCard({super.key, required this.riwayatTransaksi});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.history, color: Colors.indigo.shade800),
                    const SizedBox(width: 8),
                    const Text(
                      'Riwayat Transaksi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${riwayatTransaksi.length} Transaksi',
                    style: TextStyle(color: Colors.indigo.shade800, fontSize: 12),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            
            // TABLE HEADER
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: const Color(0xFFF0F4FA),
              child: const Row(
                children: [
                  Expanded(flex: 3, child: Text('KETERANGAN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo))),
                  Expanded(flex: 2, child: Text('NOMINAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo))),
                  Expanded(flex: 2, child: Text('TGL MASUK', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo))),
                  Expanded(flex: 2, child: Text('TGL KELUAR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo))),
                ],
              ),
            ),
            
            // TABLE BODY
            if (riwayatTransaksi.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 64),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(Icons.receipt_long, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text('Belum ada transaksi tercatat.', style: TextStyle(color: Colors.grey.shade500)),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: riwayatTransaksi.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final data = riwayatTransaksi[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(data['keterangan'])),
                        Expanded(
                          flex: 2,
                          child: Text(
                            data['nominal'],
                            style: TextStyle(color: data['color'], fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(flex: 2, child: Text(data['tgl_masuk'], style: const TextStyle(fontSize: 13))),
                        Expanded(flex: 2, child: Text(data['tgl_keluar'], style: const TextStyle(fontSize: 13))),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}