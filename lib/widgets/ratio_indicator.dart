import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RatioIndicator extends StatelessWidget {
  final double rasio;
  final double totalPemasukan;
  final double totalPengeluaran;
  final NumberFormat formatter;

  const RatioIndicator({
    super.key,
    required this.rasio,
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start, // Agar jika teks turun baris, sejajar di atas
            children: [
              // 1. Bungkus Row kiri dengan Expanded
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.show_chart, color: Colors.grey, size: 18),
                    SizedBox(width: 8),
                    // 2. Bungkus Text panjang dengan Expanded agar otomatis turun ke baris baru jika sempit
                    Expanded(
                      child: Text(
                        'Rasio Pengeluaran Terhadap Penerimaan Dana', 
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Persentase tetap di sebelah kanan
              Text('${rasio.toStringAsFixed(1)}% Terpakai', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: totalPemasukan == 0 ? 0 : rasio / 100,
            backgroundColor: Colors.grey[200],
            color: rasio > 80 ? Colors.red : (rasio > 50 ? Colors.orange : Colors.green),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 3. Bungkus juga teks bawah agar aman jika nominal uang sangat banyak
              Expanded(
                child: Text(
                  'Dana Keluar: ${formatter.format(totalPengeluaran)}', 
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Anggaran Masuk: ${formatter.format(totalPemasukan)}', 
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}