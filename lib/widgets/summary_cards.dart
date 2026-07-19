import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryCards extends StatelessWidget {
  final double totalPemasukan;
  final double totalPengeluaran;
  final double saldoAkhir;
  final NumberFormat formatter;

  const SummaryCards({
    Key? key,
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.saldoAkhir,
    required this.formatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    if (isMobile) {
      return Column(
        children: [
          _buildCard('PEMASUKAN (DEBET)', totalPemasukan, Colors.green, Icons.arrow_outward),
          const SizedBox(height: 16),
          _buildCard('PENGELUARAN (KREDIT)', totalPengeluaran, Colors.red, Icons.call_received),
          const SizedBox(height: 16),
          _buildSaldoCard(),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(child: _buildCard('PEMASUKAN (DEBET)', totalPemasukan, Colors.green, Icons.arrow_outward)),
          const SizedBox(width: 16),
          Expanded(child: _buildCard('PENGELUARAN (KREDIT)', totalPengeluaran, Colors.red, Icons.call_received)),
          const SizedBox(width: 16),
          Expanded(child: _buildSaldoCard()),
        ],
      );
    }
  }

  Widget _buildCard(String title, double amount, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Icon(icon, color: color, size: 16),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(formatter.format(amount), style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSaldoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
              const Text('SALDO AKHIR SAAT INI', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
                child: const Icon(Icons.wallet, color: Colors.white, size: 16),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(formatter.format(saldoAkhir), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}