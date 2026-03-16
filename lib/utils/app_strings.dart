/// Centralized app strings for English and German.
/// Access via `AppStrings.of(context)` after wiring up `LocaleProvider`.
class AppStrings {
  final String languageCode;
  AppStrings(this.languageCode);

  String get(String key) {
    final map = _strings[languageCode] ?? _strings['en']!;
    return map[key] ?? _strings['en']![key] ?? key;
  }

  // ─── All translatable strings ───
  static const Map<String, Map<String, String>> _strings = {
    'en': {
      // ── General ──
      'appName': 'Smart Grocery Tracker',
      'home': 'Home',
      'settings': 'Settings',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'or': 'or',
      'required': 'Required',
      'min1': 'Min 1',
      'all': 'All',
      'items': 'items',

      // ── Login ──
      'welcomeBack': 'Welcome Back',
      'signInSubtitle': 'Sign in to your account',
      'email': 'Email',
      'emailHint': 'you@email.com',
      'password': 'Password',
      'signIn': 'Sign In',
      'continueWithGoogle': 'Continue with Google',
      'noAccount': "Don't have an account? ",
      'signUp': 'Sign Up',
      'loginFailed': 'Login failed',
      'googleSignInFailed': 'Google sign-in failed',
      'enterEmail': 'Enter your email',
      'invalidEmail': 'Invalid email',
      'enterPassword': 'Enter your password',
      'atLeast6Chars': 'At least 6 characters',

      // ── Signup ──
      'createAccount': 'Create Account',
      'signupSubtitle': 'Start tracking your groceries',
      'fullName': 'Full Name',
      'nameHint': 'Your name',
      'confirmPassword': 'Confirm Password',
      'signupFailed': 'Signup failed',
      'alreadyHaveAccount': 'Already have an account? ',
      'signInLink': 'Sign In',
      'enterName': 'Enter your name',
      'enterAPassword': 'Enter a password',
      'passwordsDontMatch': "Passwords don't match",

      // ── Dashboard ──
      'hello': 'Hello',
      'trackGroceries': 'Track your groceries',
      'searchItems': 'Search items...',
      'yourItems': 'Your Items',
      'fresh': 'Fresh',
      'expiring': 'Expiring',
      'expired': 'Expired',
      'noItemsMatch': 'No items match',
      'tryDifferentFilter': 'Try a different filter',
      'noItemsYet': 'No items yet',
      'tapToAdd': 'Tap + to add your first item',
      'removed': 'removed',

      // ── Add Food ──
      'addFoodItem': 'Add Food Item',
      'editFoodItem': 'Edit Food Item',
      'category': 'Category',
      'foodName': 'Food Name',
      'selectAnItem': 'Select an item',
      'quantity': 'Quantity',
      'expiryDate': 'Expiry Date',
      'addItem': 'Add Item',
      'updateItem': 'Update Item',
      'deleteItem': 'Delete Item',
      'enterFoodName': 'Please enter a food name',
      'addedSuccess': 'added successfully',
      'updatedSuccess': 'updated successfully',
      'deleteFoodItem': 'Delete Food Item',
      'deleteConfirm': 'Are you sure you want to delete',
      'deleted': 'deleted',

      // ── Settings ──
      'profile': 'Profile',
      'account': 'Account',
      'preferences': 'Preferences',
      'changePassword': 'Change Password',
      'language': 'Language',
      'signOut': 'Sign Out',
      'signOutConfirm': 'Are you sure you want to sign out?',
      'editDisplayName': 'Edit Display Name',
      'enterYourName': 'Enter your name',
      'displayNameUpdated': 'Display name updated',
      'selectLanguage': 'Select Language',
      'languageSetTo': 'Language set to',
      'resetPassword': 'Reset Password',
      'resetPasswordMessage': 'We will send a password reset link to your email. Click the link to set your new password, and you will be logged out to log back in.',
      'sendEmail': 'Send Email',
      'noEmailAssociated': 'No email associated with this account',
      'resetEmailSent': 'Reset email sent. Please check your inbox.',
      'failedToSendReset': 'Failed to send reset email',

      // ── Expiry Status ──
      'statusFresh': 'Fresh',
      'statusExpiringSoon': 'Expiring Soon',
      'statusExpiresToday': 'Expires Today!',
      'statusExpired': 'Expired',
      'expiredAgo': 'Expired {n} day(s) ago',
      'expiresToday': 'Expires today',
      'expiresTomorrow': 'Expires tomorrow',
      'daysRemaining': '{n} days remaining',

      // ── Splash ──
      'smartGrocery': 'Smart Grocery',
      'tagline': 'Track. Manage. Save.',
    },
    'de': {
      // ── Allgemein ──
      'appName': 'Smart Grocery Tracker',
      'home': 'Startseite',
      'settings': 'Einstellungen',
      'cancel': 'Abbrechen',
      'save': 'Speichern',
      'delete': 'Löschen',
      'or': 'oder',
      'required': 'Erforderlich',
      'min1': 'Min. 1',
      'all': 'Alle',
      'items': 'Artikel',

      // ── Anmeldung ──
      'welcomeBack': 'Willkommen zurück',
      'signInSubtitle': 'Melde dich bei deinem Konto an',
      'email': 'E-Mail',
      'emailHint': 'du@email.com',
      'password': 'Passwort',
      'signIn': 'Anmelden',
      'continueWithGoogle': 'Weiter mit Google',
      'noAccount': 'Noch kein Konto? ',
      'signUp': 'Registrieren',
      'loginFailed': 'Anmeldung fehlgeschlagen',
      'googleSignInFailed': 'Google-Anmeldung fehlgeschlagen',
      'enterEmail': 'E-Mail eingeben',
      'invalidEmail': 'Ungültige E-Mail',
      'enterPassword': 'Passwort eingeben',
      'atLeast6Chars': 'Mindestens 6 Zeichen',

      // ── Registrierung ──
      'createAccount': 'Konto erstellen',
      'signupSubtitle': 'Beginne deine Lebensmittel zu verfolgen',
      'fullName': 'Vollständiger Name',
      'nameHint': 'Dein Name',
      'confirmPassword': 'Passwort bestätigen',
      'signupFailed': 'Registrierung fehlgeschlagen',
      'alreadyHaveAccount': 'Bereits ein Konto? ',
      'signInLink': 'Anmelden',
      'enterName': 'Name eingeben',
      'enterAPassword': 'Passwort eingeben',
      'passwordsDontMatch': 'Passwörter stimmen nicht überein',

      // ── Dashboard ──
      'hello': 'Hallo',
      'trackGroceries': 'Verfolge deine Lebensmittel',
      'searchItems': 'Artikel suchen...',
      'yourItems': 'Deine Artikel',
      'fresh': 'Frisch',
      'expiring': 'Bald ablaufend',
      'expired': 'Abgelaufen',
      'noItemsMatch': 'Keine Treffer',
      'tryDifferentFilter': 'Versuche einen anderen Filter',
      'noItemsYet': 'Noch keine Artikel',
      'tapToAdd': 'Tippe +, um deinen ersten Artikel hinzuzufügen',
      'removed': 'entfernt',

      // ── Essen hinzufügen ──
      'addFoodItem': 'Lebensmittel hinzufügen',
      'editFoodItem': 'Lebensmittel bearbeiten',
      'category': 'Kategorie',
      'foodName': 'Lebensmittelname',
      'selectAnItem': 'Artikel auswählen',
      'quantity': 'Menge',
      'expiryDate': 'Ablaufdatum',
      'addItem': 'Hinzufügen',
      'updateItem': 'Aktualisieren',
      'deleteItem': 'Löschen',
      'enterFoodName': 'Bitte Lebensmittelname eingeben',
      'addedSuccess': 'erfolgreich hinzugefügt',
      'updatedSuccess': 'erfolgreich aktualisiert',
      'deleteFoodItem': 'Lebensmittel löschen',
      'deleteConfirm': 'Möchtest du wirklich löschen',
      'deleted': 'gelöscht',

      // ── Einstellungen ──
      'profile': 'Profil',
      'account': 'Konto',
      'preferences': 'Einstellungen',
      'changePassword': 'Passwort ändern',
      'language': 'Sprache',
      'signOut': 'Abmelden',
      'signOutConfirm': 'Möchtest du dich wirklich abmelden?',
      'editDisplayName': 'Anzeigename bearbeiten',
      'enterYourName': 'Gib deinen Namen ein',
      'displayNameUpdated': 'Anzeigename aktualisiert',
      'selectLanguage': 'Sprache auswählen',
      'languageSetTo': 'Sprache geändert zu',
      'resetPassword': 'Passwort zurücksetzen',
      'resetPasswordMessage': 'Wir senden dir einen Link zum Zurücksetzen deines Passworts per E-Mail. Klicke auf den Link, um dein neues Passwort festzulegen. Du wirst abgemeldet, um dich erneut anzumelden.',
      'sendEmail': 'E-Mail senden',
      'noEmailAssociated': 'Keine E-Mail mit diesem Konto verknüpft',
      'resetEmailSent': 'Reset-E-Mail gesendet. Bitte überprüfe deinen Posteingang.',
      'failedToSendReset': 'Fehler beim Senden der Reset-E-Mail',

      // ── Ablaufstatus ──
      'statusFresh': 'Frisch',
      'statusExpiringSoon': 'Läuft bald ab',
      'statusExpiresToday': 'Läuft heute ab!',
      'statusExpired': 'Abgelaufen',
      'expiredAgo': 'Vor {n} Tag(en) abgelaufen',
      'expiresToday': 'Läuft heute ab',
      'expiresTomorrow': 'Läuft morgen ab',
      'daysRemaining': '{n} Tage verbleibend',

      // ── Splash ──
      'smartGrocery': 'Smart Grocery',
      'tagline': 'Verfolgen. Verwalten. Sparen.',
    },
  };
}
