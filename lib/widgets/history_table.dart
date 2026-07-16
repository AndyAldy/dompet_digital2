import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class HistoryTable extends StatelessWidget {
  final List<TransactionModel> allTransactions;
  final List<TransactionModel> filteredTransactions;
  final TextEditingController searchController;
  final String filterType;
  final VoidCallback onFilterUpdated;
  final Function(String) onFilterTypeChanged;
  final Function(TransactionModel) onEdit;
  final Function(String) onDelete;
  final NumberFormat formatter;

  const HistoryTable({
    super.key,
    required this.allTransactions,
    required this.filteredTransactions,
    required this.searchController,
    required this.filterType,
    required this.onFilterUpdated,
    required this.onFilterTypeChanged,
    required this.onEdit,
    required this.onDelete,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    double runningBalance = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Section
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: searchController,
                onChanged: (_) => onFilterUpdated(),
                decoration: InputDecoration(
                  hintText: 'Cari transaksi berdasarkan keterangan...',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: filterType,
                    isExpanded: true,
                    icon: const Icon(Icons.filter_list, size: 18),
                    items: ['Semua Tipe', 'Debit', 'Kredit'].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) onFilterTypeChanged(val);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        
        // Table Section
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('RIWAYAT TRANSAKSI BUKU KAS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                    Text('${filteredTransactions.length} dari ${allTransactions.length} Entri', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (filteredTransactions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Column(
                      children: const [
                        Icon(Icons.search_off, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Tidak Ada Transaksi Ditemukan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Coba ubah filter pencarian Anda atau rekam pengeluaran/pemasukan\nbaru pada formulir kas.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('TANGGAL', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('KETERANGAN', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('DEBET (+)', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('KREDIT (-)', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('SALDO', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('AKSI', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                    ],
                    rows: filteredTransactions.map((tx) {
                      if (tx.type == 'debit') {
                        runningBalance += tx.amount;
                      } else {
                        runningBalance -= tx.amount;
                      }
                      
                      return DataRow(
                        cells: [
                          DataCell(Text(dateFormatter.format(tx.date))),
                          DataCell(Text(tx.description)),
                          DataCell(Text(tx.type == 'debit' ? formatter.format(tx.amount) : '-', style: const TextStyle(color: Colors.green))),
                          DataCell(Text(tx.type == 'kredit' ? formatter.format(tx.amount) : '-', style: const TextStyle(color: Colors.red))),
                          DataCell(Text(formatter.format(runningBalance), style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 16, color: Colors.blue),
                                onPressed: () => onEdit(tx),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                                onPressed: () => onDelete(tx.id),
                                tooltip: 'Hapus',
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}