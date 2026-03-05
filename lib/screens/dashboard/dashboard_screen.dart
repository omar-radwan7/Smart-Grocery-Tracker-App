import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_grocery_tracker/models/food_item.dart';
import 'package:smart_grocery_tracker/providers/auth_provider.dart';
import 'package:smart_grocery_tracker/providers/food_provider.dart';
import 'package:smart_grocery_tracker/screens/add_food/add_food_screen.dart';
import 'package:smart_grocery_tracker/utils/app_theme.dart';
import 'package:smart_grocery_tracker/widgets/category_filter_bar.dart';
import 'package:smart_grocery_tracker/widgets/food_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final food = context.read<FoodProvider>();
      if (auth.user != null) food.listenToFoodItems(auth.user!.uid);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddFood({FoodItem? item}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddFoodScreen(existingItem: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final food = context.watch<FoodProvider>();
    final name = (auth.user?.displayName ?? 'there').split(' ').first;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ─── Top bar ───
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    // Avatar circle
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.heroStart.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.heroStart,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $name',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Track your groceries',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _iconBtn(
                      _showSearch ? Icons.close : Icons.search,
                      () {
                        setState(() {
                          _showSearch = !_showSearch;
                          if (!_showSearch) {
                            _searchController.clear();
                            food.setSearchQuery('');
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ─── Search (animated) ───
            if (_showSearch)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: food.setSearchQuery,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      prefixIcon: const Icon(Icons.search, size: 20, color: AppTheme.textHint),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: AppTheme.textHint),
                              onPressed: () {
                                _searchController.clear();
                                food.setSearchQuery('');
                              })
                          : null,
                    ),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ─── Hero summary card ───
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildHeroCard(food),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ─── Category filter ───
            SliverToBoxAdapter(
              child: CategoryFilterBar(
                selectedCategory: food.selectedCategory,
                onCategorySelected: food.setCategory,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // ─── Section header ───
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 4),
                child: Row(
                  children: [
                    const Text(
                      'Your Items',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${food.foodItems.length} items',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 4)),

            // ─── Food grid or empty state ───
            if (food.isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppTheme.primaryGreen),
                ),
              )
            else if (food.foodItems.isEmpty)
              SliverFillRemaining(child: _buildEmpty(food))
            else
              _buildFoodGrid(food, auth),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  // ─── Hero card ───
  Widget _buildHeroCard(FoodProvider food) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.heroStart, AppTheme.heroEnd],
        ),
        borderRadius: BorderRadius.circular(AppTheme.rXl),
        boxShadow: AppTheme.heroShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Total items circle
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(40),
                  border: Border.all(color: Colors.white.withAlpha(60), width: 3),
                ),
                child: Center(
                  child: Text(
                    food.allItems.length.toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Stats column
              Expanded(
                child: Column(
                  children: [
                    _heroStat('Fresh', food.normalCount, AppTheme.freshGreen),
                    const SizedBox(height: 8),
                    _heroStat('Expiring', food.expiringSoonCount, AppTheme.warningAmber),
                    const SizedBox(height: 8),
                    _heroStat('Expired', food.expiredCount, AppTheme.expiredRed),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroStat(String label, int count, Color color) {
    final total = context.read<FoodProvider>().allItems.length;
    final pct = total > 0 ? count / total : 0.0;

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white.withAlpha(200),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: Colors.white.withAlpha(40),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 28,
          child: Text(
            count.toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // ─── 2-column grid ───
  Widget _buildFoodGrid(FoodProvider food, AuthProvider auth) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.82,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = food.foodItems[index];
            return FoodCard(
              item: item,
              onTap: () => _navigateToAddFood(item: item),
              onDelete: () {
                food.deleteFoodItem(auth.user!.uid, item.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.name} removed'),
                    backgroundColor: AppTheme.textDark,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.rSm),
                    ),
                  ),
                );
              },
            );
          },
          childCount: food.foodItems.length,
        ),
      ),
    );
  }

  // ─── Empty state ───
  Widget _buildEmpty(FoodProvider food) {
    final hasFilter = food.selectedCategory != null || food.searchQuery.isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.surfaceGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_basket_outlined,
                size: 36, color: AppTheme.textLight),
          ),
          const SizedBox(height: 20),
          Text(
            hasFilter ? 'No items match' : 'No items yet',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasFilter ? 'Try a different filter' : 'Tap + to add your first item',
            style: const TextStyle(fontSize: 13, color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppTheme.softShadow,
        ),
        child: Icon(icon, size: 20, color: AppTheme.textDark),
      ),
    );
  }
}
