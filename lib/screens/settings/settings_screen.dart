import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_grocery_tracker/providers/auth_provider.dart';
import 'package:smart_grocery_tracker/providers/locale_provider.dart';
import 'package:smart_grocery_tracker/utils/app_strings.dart';
import 'package:smart_grocery_tracker/utils/app_theme.dart';

/// Settings screen with Profile, Account (email/password), and Preferences.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final user = authProvider.user;
    final s = AppStrings(localeProvider.languageCode);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header
              Text(
                s.get('settings'),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 28),

              // ───── Profile Section ─────
              _buildSectionHeader(s.get('profile')),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.primaryGreen,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      child: user?.photoURL == null
                          ? Text(
                              (user?.displayName ?? 'U')
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryGreen,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? 'User',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppTheme.primaryGreen, size: 22),
                      onPressed: () => _showEditNameDialog(context, s),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ───── Account Section ─────
              _buildSectionHeader(s.get('account')),
              const SizedBox(height: 12),
              _buildSettingsCard(
                children: [
                  _buildSettingsTile(
                    icon: Icons.lock_outline,
                    title: s.get('changePassword'),
                    subtitle: '••••••••',
                    onTap: () => _showChangePasswordDialog(context, s),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ───── Preferences Section ─────
              _buildSectionHeader(s.get('preferences')),
              const SizedBox(height: 12),
              _buildSettingsCard(
                children: [
                  _buildSettingsTile(
                    icon: Icons.language_outlined,
                    title: s.get('language'),
                    subtitle: localeProvider.languageName,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withAlpha(50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        localeProvider.languageName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                    onTap: () => _showLanguagePicker(context, s),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ───── Sign Out ─────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _handleSignOut(context, s),
                  icon: const Icon(Icons.logout, color: AppTheme.expiredRed),
                  label: Text(
                    s.get('signOut'),
                    style: const TextStyle(
                      color: AppTheme.expiredRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.expiredRed, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ───── UI Builders ─────

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.textMedium,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withAlpha(18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryGreen, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppTheme.textDark,
        ),
      ),
      subtitle: trailing == null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textMedium,
              ),
            )
          : null,
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: AppTheme.textHint, size: 22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  // ───── Dialogs ─────

  void _showEditNameDialog(BuildContext context, AppStrings s) {
    final controller = TextEditingController(
      text: context.read<AuthProvider>().user?.displayName ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(s.get('editDisplayName')),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: s.get('enterYourName'),
            prefixIcon: const Icon(Icons.person_outline),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                final success = await context
                    .read<AuthProvider>()
                    .updateDisplayName(controller.text.trim());
                if (context.mounted) {
                  Navigator.pop(context);
                  if (success) {
                    _showSuccessSnackbar(s.get('displayNameUpdated'));
                  }
                }
              }
            },
            child: Text(s.get('save')),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, AppStrings s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(s.get('resetPassword')),
        content: Text(s.get('resetPasswordMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = context.read<AuthProvider>().user?.email;
              if (email == null) {
                _showErrorSnackbar(s.get('noEmailAssociated'));
                return;
              }
              final success =
                  await context.read<AuthProvider>().sendPasswordReset(email);
              if (context.mounted) {
                Navigator.pop(context);
                if (success) {
                  _showSuccessSnackbar(s.get('resetEmailSent'));
                  await context.read<AuthProvider>().signOut();
                } else {
                  _showErrorSnackbar(
                      context.read<AuthProvider>().error ??
                          s.get('failedToSendReset'));
                }
              }
            },
            child: Text(s.get('sendEmail')),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, AppStrings s) {
    final localeProvider = context.read<LocaleProvider>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(s.get('selectLanguage')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageTile(ctx, localeProvider, 'English', 'en'),
            const Divider(height: 1),
            _buildLanguageTile(ctx, localeProvider, 'Deutsch', 'de'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext dialogContext,
    LocaleProvider localeProvider,
    String language,
    String code,
  ) {
    final isSelected = localeProvider.languageCode == code;
    return ListTile(
      title: Text(language),
      subtitle: Text(code.toUpperCase()),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppTheme.primaryGreen)
          : null,
      onTap: () {
        localeProvider.setLanguage(code);
        Navigator.pop(dialogContext);
        final newS = AppStrings(code);
        _showSuccessSnackbar('${newS.get('languageSetTo')} $language');
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _handleSignOut(BuildContext context, AppStrings s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(s.get('signOut')),
        content: Text(s.get('signOutConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.expiredRed,
            ),
            child: Text(s.get('signOut')),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.expiredRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
