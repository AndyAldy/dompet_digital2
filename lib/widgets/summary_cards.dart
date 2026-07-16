import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryCards extends StatelessWidget {
  final double totalPemasukan;
  final double totalPengeluaran;
  final double saldoAkhir;
  final NumberFormat formatter;

  const SummaryCards({
    super.key,
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.saldoAkhir,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildCard('TOTAL PEMASUKAN (DEBET)', totalPemasukan, Colors.green, Icons.arrow_outward)),
        const SizedBox(width: 16),
        Expanded(child: _buildCard('TOTAL PENGELUARAN (KREDIT)', totalPengeluaran, Colors.red, Icons.call_received)),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('SALDO AKHIR SAAT INI', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
                      child: const Icon(Icons.wallet, color: Colors.white, size: 16),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Text(formatter.format(saldoAkhir), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Net sisa anggaran kas kecil berjalan', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Icon(icon, color: color, size: 16),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(formatter.format(amount), style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title.contains('DEBET') ? 'Akumulasi dana kas masuk' : 'Akumulasi pengeluaran kas kecil', style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}