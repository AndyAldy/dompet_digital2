import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

// Import model & widgets
import '../models/transaction_model.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/summary_cards.dart';
import '../widgets/ratio_indicator.dart';
import '../widgets/transaction_form.dart';
import '../widgets/history_table.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<TransactionModel> transactions = [];
  
  // Controllers
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'debit';
  
  // Search & Filter
  final TextEditingController _searchController = TextEditingController();
  String _filterType = 'Semua Tipe';
  
  TransactionModel? _editingTransaction;

  final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

  double get totalPemasukan => transactions.where((t) => t.type == 'debit').fold(0, (sum, item) => sum + item.amount);
  double get totalPengeluaran => transactions.where((t) => t.type == 'kredit').fold(0, (sum, item) => sum + item.amount);
  double get saldoAkhir => totalPemasukan - totalPengeluaran;
  double get rasioPengeluaran => totalPemasukan == 0 ? 0 : (totalPengeluaran / totalPemasukan) * 100;

  void _submitTransaction() {
    if (_descController.text.isEmpty || _amountController.text.isEmpty) return;
    
    double amount = double.tryParse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (amount <= 0) return;

    setState(() {
      if (_editingTransaction != null) {
        _editingTransaction!.date = _selectedDate;
        _editingTransaction!.type = _selectedType;
        _editingTransaction!.description = _descController.text;
        _editingTransaction!.amount = amount;
        _editingTransaction = null;
      } else {
        transactions.add(TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: _selectedDate,
          type: _selectedType,
          description: _descController.text,
          amount: amount,
        ));
      }
      
      transactions.sort((a, b) => a.date.compareTo(b.date));
      _descController.clear();
      _amountController.clear();
      _selectedDate = DateTime.now();
    });
  }

  void _editTransaction(TransactionModel tx) {
    setState(() {
      _editingTransaction = tx;
      _selectedDate = tx.date;
      _selectedType = tx.type;
      _descController.text = tx.description;
      _amountController.text = tx.amount.toInt().toString();
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _resetData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Data'),
        content: const Text('Apakah Anda yakin ingin menghapus semua data transaksi, saldo, dan rasio? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                transactions.clear();
                _descController.clear();
                _amountController.clear();
                _editingTransaction = null;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua data berhasil direset.')));
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _cetakPDF() async {
    if (transactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Belum ada transaksi untuk dicetak.')));
      return;
    }

    final pdf = pw.Document();
    double runningBalance = 0;
    List<List<String>> tableData = [];
    
    List<TransactionModel> sortedTx = List.from(transactions)..sort((a, b) => a.date.compareTo(b.date));
    for (var tx in sortedTx) {
      runningBalance += tx.type == 'debit' ? tx.amount : -tx.amount;
      tableData.add([
        dateFormatter.format(tx.date),
        tx.description,
        tx.type == 'debit' ? currencyFormatter.format(tx.amount) : '-',
        tx.type == 'kredit' ? currencyFormatter.format(tx.amount) : '-',
        currencyFormatter.format(runningBalance),
      ]);
    }
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Laporan Arus Kas Operasional', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Periode: ${DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now())}'),
              pw.SizedBox(height: 24),
              pw.TableHelper.fromTextArray(
                headers: ['Tanggal', 'Keterangan', 'Debit (+)', 'Kredit (-)', 'Saldo'],
                data: tableData,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Laporan_Kas_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  void _eksporCSV() {
    if (transactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Belum ada transaksi untuk diekspor.')));
      return;
    }

    String csvData = "Tanggal,Keterangan,Debit,Kredit,Saldo\n";
    double runningBalance = 0;
    
    List<TransactionModel> sortedTx = List.from(transactions)..sort((a, b) => a.date.compareTo(b.date));
    for (var tx in sortedTx) {
      runningBalance += tx.type == 'debit' ? tx.amount : -tx.amount;
      String debit = tx.type == 'debit' ? tx.amount.toInt().toString() : '0';
      String kredit = tx.type == 'kredit' ? tx.amount.toInt().toString() : '0';
      String safeDescription = tx.description.replaceAll('"', '""');
      csvData += "${dateFormatter.format(tx.date)},\"$safeDescription\",$debit,$kredit,${runningBalance.toInt()}\n";
    }

    Share.share(csvData, subject: 'Riwayat_Transaksi_Kas.csv');
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TransactionModel> filteredTransactions = transactions.where((tx) {
      bool matchSearch = tx.description.toLowerCase().contains(_searchController.text.toLowerCase());
      bool matchType = _filterType == 'Semua Tipe' || 
                      (_filterType == 'Debit' && tx.type == 'debit') || 
                      (_filterType == 'Kredit' && tx.type == 'kredit');
      return matchSearch && matchType;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(
              onCetakPDF: _cetakPDF,
              onEksporCSV: _eksporCSV,
              onResetData: _resetData,
            ),
            const SizedBox(height: 24),
            SummaryCards(
              totalPemasukan: totalPemasukan,
              totalPengeluaran: totalPengeluaran,
              saldoAkhir: saldoAkhir,
              formatter: currencyFormatter,
            ),
            const SizedBox(height: 24),
            RatioIndicator(
              rasio: rasioPengeluaran,
              totalPemasukan: totalPemasukan,
              totalPengeluaran: totalPengeluaran,
              formatter: currencyFormatter,
            ),
            const SizedBox(height: 24),
            TransactionForm(
              descController: _descController,
              amountController: _amountController,
              selectedDate: _selectedDate,
              selectedType: _selectedType,
              isEditing: _editingTransaction != null,
              onSelectDate: _selectDate,
              onTypeChanged: (type) => setState(() => _selectedType = type),
              onSubmit: _submitTransaction,
            ),
            const SizedBox(height: 24),
            HistoryTable(
              allTransactions: transactions,
              filteredTransactions: filteredTransactions,
              searchController: _searchController,
              filterType: _filterType,
              onFilterUpdated: () => setState(() {}),
              onFilterTypeChanged: (type) => setState(() => _filterType = type),
              onEdit: _editTransaction,
              onDelete: _deleteTransaction,
              formatter: currencyFormatter,
            ),
          ],
        ),
      ),
    );
  }
}