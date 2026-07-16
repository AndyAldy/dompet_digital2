import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  // Tambahkan variabel ini untuk mendeteksi halaman yang sedang aktif
  final String currentRoute;

  const Sidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FinTrack',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  'Corporate Finance',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Tambahkan parameter route ('/overview', '/accounts', dll)
          _buildNavItem(
            context,
            Icons.grid_view_rounded,
            'Overview',
            '/overview',
          ),
          _buildNavItem(
            context,
            Icons.account_balance_wallet_outlined,
            'Accounts',
            '/accounts',
          ),
          const Spacer(),
          const Divider(),
          _buildNavItem(context, Icons.help_outline, 'Help Center', '/help'),
          _buildNavItem(
            context,
            Icons.logout,
            'Sign Out',
            '/logout',
            isDanger: true,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String title,
    String routeName, {
    bool isDanger = false,
  }) {
    // Menu aktif jika routeName sama dengan currentRoute yang dilempar dari Screen
    bool isActive = currentRoute == routeName;

    Color color = isDanger
        ? Colors.red
        : (isActive ? Colors.indigo : Colors.grey.shade700);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.indigo.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 20),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () {
          // Hanya pindah halaman jika menu yang diklik BUKAN menu yang sedang aktif
          if (!isActive) {
            if (routeName == '/logout') {
              // TODO: Tambahkan logika logout, lalu lempar ke layar login
              // Navigator.pushReplacementNamed(context, '/login');
            } else {
              // Gunakan pushReplacementNamed agar halaman tidak saling menumpuk
              Navigator.pushReplacementNamed(context, routeName);
            }
          }
        },
      ),
    );
  }
}
