import 'package:flutter/material.dart';
import 'package:smart_grocery_tracker/screens/add_food/add_food_screen.dart';
import 'package:smart_grocery_tracker/screens/dashboard/dashboard_screen.dart';
import 'package:smart_grocery_tracker/screens/settings/settings_screen.dart';
import 'package:smart_grocery_tracker/utils/app_theme.dart';

/// Top-level shell with bottom navigation between dashboard and settings.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  /// Destinations shown in the bottom navigation bar.
  final List<Widget> _screens = const [
    DashboardScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AddFoodScreen())),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.accentPink,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentPink.withAlpha(80),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 26),
                  ),
                ),
                _navItem(1, Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i, IconData icon, IconData active, String label) {
    final on = _currentIndex == i;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = i),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(on ? active : icon, size: 24,
              color: on ? AppTheme.textDark : AppTheme.textHint),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                color: on ? AppTheme.textDark : AppTheme.textHint,
              )),
        ],
      ),
    );
  }
}
