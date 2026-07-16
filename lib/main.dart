import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

final ValueNotifier<String> themeNotifier = ValueNotifier('system');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 3. Inisialisasi format data untuk Indonesia
  await initializeDateFormatting('id_ID', null).then((_) {
    // 4. Jalankan aplikasi setelah inisialisasi selesai
    runApp(const FinTrackApp());
    });
  }

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. BUNGKUS MATERIAL APP DENGAN ValueListenableBuilder
    return ValueListenableBuilder<String>(
      valueListenable: themeNotifier,
      builder: (context, currentThemeMode, child) {
        // 3. LOGIKA UNTUK MENENTUKAN THEMEMODE
        ThemeMode themeMode;
        if (currentThemeMode == 'dark') {
          themeMode = ThemeMode.dark;
        } else if (currentThemeMode == 'light') {
          themeMode = ThemeMode.light;
        } else {
          themeMode = ThemeMode.system;
        }

        return MaterialApp(
          title: 'FinTrack Dashboard',
          debugShowCheckedModeBanner: false,

          // Konfigurasi Tema Terang (Light Mode)
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            scaffoldBackgroundColor: const Color(0xFFF8F9FE),
            fontFamily: 'Segoe UI',
            brightness: Brightness.light,
          ),

          // Konfigurasi Tema Gelap (Dark Mode)
          darkTheme: ThemeData(
            primarySwatch: Colors.indigo,
            scaffoldBackgroundColor: const Color(0xFF121212),
            fontFamily: 'Segoe UI',
            brightness: Brightness.dark,
          ),

          // Terapkan themeMode yang didapat dari themeNotifier
          themeMode: themeMode,

          initialRoute: '/overview',

          // Daftarkan semua rute di sini
          routes: {
            '/overview': (context) => const DashboardScreen(),
          },
        );
      },
    );
  }
}
