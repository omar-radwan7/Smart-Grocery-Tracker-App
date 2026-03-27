import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:smart_grocery_tracker/providers/locale_provider.dart';
import 'package:smart_grocery_tracker/screens/add_food/add_food_screen.dart';
import 'package:smart_grocery_tracker/screens/dashboard/dashboard_screen.dart';
import 'package:smart_grocery_tracker/screens/settings/settings_screen.dart';
import 'package:smart_grocery_tracker/utils/app_strings.dart';
import 'package:smart_grocery_tracker/utils/app_theme.dart';

/// Top-level shell with animated curved bottom navigation.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  /// Destinations shown in the bottom navigation bar.
  final List<Widget> _screens = const [
    DashboardScreen(),
    AddFoodScreen(), // Make it a tab
    SettingsScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleProvider>().languageCode;
    final s = AppStrings(lang);
    
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (idx) => setState(() => _currentIndex = idx),
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: Container(
        color: Colors.white, // Ensure the "bottom" part is white
        child: SafeArea(
          top: false,
          child: CurvedNavigationBar(
            index: _currentIndex,
            height: 70, // Slightly taller for labels
            items: <Widget>[
              _buildNavItem(Icons.home_rounded, s.get('home'), _currentIndex == 0),
              _buildNavItem(Icons.add_rounded, s.get('addItem'), _currentIndex == 1),
              _buildNavItem(Icons.settings_rounded, s.get('settings'), _currentIndex == 2),
            ],
            color: Colors.white,
            buttonBackgroundColor: _currentIndex == 1 ? AppTheme.accentPink : AppTheme.heroStart,
            backgroundColor: AppTheme.scaffoldBg, // Blend with body
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 28,
          color: isActive ? Colors.white : AppTheme.textMedium,
        ),
        if (!isActive) // Show label only when NOT active (like some modern apps)
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppTheme.textMedium),
          ),
      ],
    );
  }
}
