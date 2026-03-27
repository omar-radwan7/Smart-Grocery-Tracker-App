import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_grocery_tracker/models/food_item.dart';
import 'package:smart_grocery_tracker/providers/auth_provider.dart';
import 'package:smart_grocery_tracker/providers/food_provider.dart';
import 'package:smart_grocery_tracker/providers/locale_provider.dart';
import 'package:smart_grocery_tracker/utils/app_strings.dart';
import 'package:smart_grocery_tracker/utils/app_theme.dart';
import 'package:smart_grocery_tracker/utils/constants.dart';

// ignore_for_file: deprecated_member_use

/// Screen to add or edit a food item.
class AddFoodScreen extends StatefulWidget {
  final FoodItem? existingItem;

  const AddFoodScreen({super.key, this.existingItem});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedCategory = AppConstants.foodCategories.first;
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));
  bool _isSubmitting = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  bool get _isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();

    if (_isEditing) {
      final item = widget.existingItem!;
      _nameController.text = item.name;
      _quantityController.text = item.quantity.toString();
      _selectedCategory = item.category;
      _expiryDate = item.expiryDate;
    } else {
      _quantityController.text = '1';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primaryGreen,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    final s = AppStrings(context.read<LocaleProvider>().languageCode);

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.get('enterFoodName')),
          backgroundColor: AppTheme.expiredRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final authProvider = context.read<AuthProvider>();
    final foodProvider = context.read<FoodProvider>();
    final uid = authProvider.user!.uid;

    final item = FoodItem(
      id: _isEditing ? widget.existingItem!.id : '',
      name: _nameController.text.trim(),
      category: _selectedCategory,
      quantity: int.tryParse(_quantityController.text.trim()) ?? 1,
      expiryDate: _expiryDate,
      imageUrl: AppTheme.itemImagePath(_nameController.text.trim(), _selectedCategory),
      createdAt: _isEditing ? widget.existingItem!.createdAt : DateTime.now(),
    );

    bool success;
    if (_isEditing) {
      success = await foodProvider.updateFoodItem(uid, item);
    } else {
      success = await foodProvider.addFoodItem(uid, item);
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      final popped = await Navigator.maybePop(context);
      if (!popped) {
        // We're likely in a bottom-nav tab; reset form for next item
        _nameController.clear();
        _quantityController.text = '1';
        _selectedCategory = AppConstants.foodCategories.first;
        _expiryDate = DateTime.now().add(const Duration(days: 7));
        setState(() => _isSubmitting = false);
      }
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? '${item.name} ${s.get('updatedSuccess')}'
                : '${item.name} ${s.get('addedSuccess')}',
          ),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _handleDelete() async {
    final s = AppStrings(context.read<LocaleProvider>().languageCode);
    final authProvider = context.read<AuthProvider>();
    final foodProvider = context.read<FoodProvider>();
    final uid = authProvider.user!.uid;
    final item = widget.existingItem!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.get('deleteFoodItem')),
        content: Text('${s.get('deleteConfirm')} "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(s.get('cancel'), style: const TextStyle(color: AppTheme.textMedium)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(s.get('delete'), style: const TextStyle(color: AppTheme.expiredRed)),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
      ),
    );

    if (confirm != true) return;

    if (!mounted) return;
    setState(() => _isSubmitting = true);

    final success = await foodProvider.deleteFoodItem(uid, item.id);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      await Navigator.maybePop(context);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.existingItem!.name} ${s.get('deleted')}'),
          backgroundColor: AppTheme.textDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.textDark,
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceGrey),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppTheme.primaryGreen),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleProvider>().languageCode;
    final s = AppStrings(lang);
    final dateFormat = DateFormat('EEEE, MMM dd, yyyy', lang);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: Text(
          _isEditing ? s.get('editFoodItem') : s.get('addFoodItem'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Category Dropdown
                  _buildSectionLabel(s.get('category')),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.surfaceGrey),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: AppConstants.foodCategories
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(AppConstants.categoryDisplay(cat, lang)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                            _nameController.clear();
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.category_outlined,
                            color: AppTheme.textHint),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      borderRadius: BorderRadius.circular(14),
                      dropdownColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name Field
                  _buildSectionLabel(s.get('foodName')),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      List<String> items = List.from(AppConstants.categoryItems[_selectedCategory] ?? []);
                      if (items.isEmpty) {
                        items.add('Misc Item');
                      }
                      final currentName = _nameController.text.trim();
                      if (currentName.isNotEmpty && !items.contains(currentName)) {
                        items.add(currentName);
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.surfaceGrey),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: currentName.isEmpty ? null : currentName,
                          hint: Text(s.get('selectAnItem'), style: const TextStyle(color: AppTheme.textHint, fontSize: 14)),
                          items: items
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(AppConstants.itemDisplay(item, lang)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _nameController.text = value;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.fastfood_outlined,
                                color: AppTheme.textHint),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          borderRadius: BorderRadius.circular(14),
                          dropdownColor: Colors.white,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Quantity Field
                  _buildSectionLabel(s.get('quantity')),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onPressed: () {
                          final current =
                              int.tryParse(_quantityController.text) ?? 1;
                          if (current > 1) {
                            _quantityController.text =
                                (current - 1).toString();
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: AppTheme.surfaceGrey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: AppTheme.surfaceGrey),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return s.get('required');
                            }
                            final qty = int.tryParse(value.trim());
                            if (qty == null || qty < 1) {
                              return s.get('min1');
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildQuantityButton(
                        icon: Icons.add,
                        onPressed: () {
                          final current =
                              int.tryParse(_quantityController.text) ?? 0;
                          _quantityController.text =
                              (current + 1).toString();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Expiry Date Picker
                  _buildSectionLabel(s.get('expiryDate')),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickExpiryDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.surfaceGrey),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              color: AppTheme.textHint, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              dateFormat.format(_expiryDate),
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down,
                              color: AppTheme.textHint),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Submit Button
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _isEditing ? s.get('updateItem') : s.get('addItem'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 54,
                      child: OutlinedButton(
                        onPressed: _isSubmitting ? null : _handleDelete,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.expiredRed,
                          side: const BorderSide(color: AppTheme.expiredRed, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          s.get('deleteItem'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}