import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onCetakPDF;
  final VoidCallback onEksporCSV;
  final VoidCallback onResetData;

  const DashboardHeader({
    super.key,
    required this.onCetakPDF,
    required this.onEksporCSV,
    required this.onResetData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Sistem Kas Kecil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Laporan Arus Kas Operasional Bulanan', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('PERIODE AKTIF', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text(DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now()), style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 24),
              OutlinedButton.icon(
                icon: const Icon(Icons.picture_as_pdf, size: 18),
                label: const Text('Cetak PDF'),
                onPressed: onCetakPDF,
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Ekspor CSV'),
                onPressed: onEksporCSV,
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh, size: 18, color: Colors.red),
                label: const Text('Reset Data', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                onPressed: onResetData,
              ),
            ],
          )
        ],
      ),
    );
  }
}