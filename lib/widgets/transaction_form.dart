import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatelessWidget {
  final TextEditingController descController;
  final TextEditingController amountController;
  final DateTime selectedDate;
  final String selectedType;
  final bool isEditing;
  final VoidCallback onSelectDate;
  final Function(String) onTypeChanged;
  final VoidCallback onSubmit;

  const TransactionForm({
    super.key,
    required this.descController,
    required this.amountController,
    required this.selectedDate,
    required this.selectedType,
    required this.isEditing,
    required this.onSelectDate,
    required this.onTypeChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.add_box, color: Colors.grey),
              SizedBox(width: 8),
              Text('Catat Transaksi Baru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TANGGAL TRANSAKSI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: onSelectDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(dateFormatter.format(selectedDate)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('JENIS ARUS KAS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => onTypeChanged('debit'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: selectedType == 'debit' ? Colors.green.withOpacity(0.1) : Colors.transparent,
                                border: Border.all(color: selectedType == 'debit' ? Colors.green : Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text('Debit (Masuk)', style: TextStyle(color: selectedType == 'debit' ? Colors.green : Colors.grey, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => onTypeChanged('kredit'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: selectedType == 'kredit' ? Colors.red.withOpacity(0.1) : Colors.transparent,
                                border: Border.all(color: selectedType == 'kredit' ? Colors.red : Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text('Kredit (Keluar)', style: TextStyle(color: selectedType == 'kredit' ? Colors.red : Colors.grey, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('KETERANGAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(
            controller: descController,
            decoration: InputDecoration(
              hintText: 'Contoh: Perlengkapan Bazaar...',
              prefixIcon: const Icon(Icons.description, size: 18),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('JUMLAH NOMINAL (RUPIAH)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Rp 0',
              prefixIcon: const Icon(Icons.attach_money, size: 18),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: onSubmit,
              child: Text(
                isEditing ? 'Simpan Perubahan' : '+ Catat Transaksi',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}