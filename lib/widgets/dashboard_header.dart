import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onCetakPDF;
  final VoidCallback onEksporCSV;
  final VoidCallback onResetData;

  const DashboardHeader({
    Key? key,
    required this.onCetakPDF,
    required this.onEksporCSV,
    required this.onResetData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Deteksi apakah lebar layar kurang dari 800 pixel (Mobile/Tablet kecil)
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: isMobile 
          ? _buildMobileLayout() 
          : _buildDesktopLayout(),
    );
  }

  // Tampilan untuk Desktop / Web
  Widget _buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTitle(),
        _buildActions(),
      ],
    );
  }

  // Tampilan untuk Mobile (ditumpuk ke bawah)
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        const SizedBox(height: 16),
        _buildActions(),
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Sistem Kas Kecil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Laporan Arus Kas Bulanan', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PERIODE AKTIF', style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 11, 11, 11), fontWeight: FontWeight.bold)),
            Text(DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color.fromARGB(255, 0, 0, 0))),
          ],
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.picture_as_pdf, size: 16),
          label: const Text('PDF', style: TextStyle(fontSize: 12)),
          onPressed: onCetakPDF,
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.download, size: 16),
          label: const Text('CSV', style: TextStyle(fontSize: 12)),
          onPressed: onEksporCSV,
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.refresh, size: 16, color: Colors.red),
          label: const Text('Reset', style: TextStyle(color: Colors.red, fontSize: 12)),
          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
          onPressed: onResetData,
        ),
      ],
    );
  }
}