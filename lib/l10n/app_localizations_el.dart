// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Σουντόκου';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline =>
      'Ήρεμη συγκέντρωση, ένα καθημερινό διάλειμμα για το μυαλό';

  @override
  String get newGame => 'Νέο παιχνίδι';

  @override
  String get records => 'Ιστορικό';

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get continueTitle => 'Παιχνίδι σε εξέλιξη';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString ολοκληρώθηκε · $time πέρασαν';
  }

  @override
  String get overwriteTitle => 'Έναρξη νέου παιχνιδιού;';

  @override
  String get overwriteBody => 'Το παιχνίδι σε εξέλιξη θα χαθεί.';

  @override
  String get saveIncompatible =>
      'Ένα αποθηκευμένο παιχνίδι από παλαιότερη έκδοση δεν μπορούσε να συνεχιστεί και διαγράφηκε.';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get removeAds => 'Κατάργηση διαφημίσεων';

  @override
  String removeAdsWithPrice(String price) {
    return 'Κατάργηση διαφημίσεων $price';
  }

  @override
  String get removeAdsDesc => 'Μία αγορά, χωρίς διαφημίσεις για πάντα';

  @override
  String get removeAdsLongDesc =>
      'Καταργήστε μόνιμα όλες τις διαφημίσεις με μία αγορά και συγκεντρωθείτε πλήρως στον γρίφο.';

  @override
  String get adsRemoved => 'Οι διαφημίσεις καταργήθηκαν';

  @override
  String get purchasePending => 'Επεξεργασία';

  @override
  String get storeUnavailable => 'Δεν είναι δυνατή η σύνδεση με το κατάστημα';

  @override
  String get restorePurchases => 'Επαναφορά αγορών';

  @override
  String get restoreRequested => 'Έλεγχος ιστορικού αγορών';

  @override
  String get purchaseFailed =>
      'Η πληρωμή δεν ολοκληρώθηκε. Δοκιμάστε ξανά αργότερα';

  @override
  String get restoreFailed =>
      'Δεν ήταν δυνατή η επαναφορά αγορών. Δοκιμάστε ξανά αργότερα';

  @override
  String get restoreNone => 'Δεν υπάρχουν αγορές για επαναφορά';

  @override
  String get resultRemoveAdsLine => 'Θέλετε να παίζετε χωρίς διαφημίσεις;';

  @override
  String get chooseDifficulty => 'Επιλογή δυσκολίας';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Τέλος μετά από $max λάθη · Η αναίρεση δεν μειώνει τα λάθη',
      one: 'Τέλος μετά από $max λάθος · Η αναίρεση δεν μειώνει τα λάθη',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Ξεκινάμε σε λίγο';

  @override
  String get preparingSub => 'Δημιουργία νέου γρίφου…';

  @override
  String get puzzleFailed =>
      'Δεν ήταν δυνατή η δημιουργία γρίφου. Δοκιμάστε ξανά';

  @override
  String get back => 'Πίσω';

  @override
  String get more => 'Περισσότερα';

  @override
  String get restartSame => 'Από την αρχή';

  @override
  String get restartConfirmTitle => 'Να ξεκινήσει αυτός ο γρίφος από την αρχή;';

  @override
  String get restartConfirmBody =>
      'Οι αριθμοί, ο χρόνος και τα λάθη θα μηδενιστούν.';

  @override
  String get instantCheck => 'Άμεσος έλεγχος';

  @override
  String mistakes(int count, int max) {
    return 'Λάθη $count/$max';
  }

  @override
  String get undo => 'Αναίρεση';

  @override
  String get erase => 'Σβήσιμο';

  @override
  String get memo => 'Σημειώσεις';

  @override
  String get memoOn => 'Σημειώσεις ΝΑΙ';

  @override
  String get mistakeKept => 'Η αναίρεση δεν μειώνει τον αριθμό λαθών';

  @override
  String cellEmpty(int row, int column) {
    return 'Γραμμή $row, στήλη $column, κενό';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Γραμμή $row, στήλη $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, απομένουν $count';
  }

  @override
  String get cleared => 'Λύθηκε!';

  @override
  String get gameOver => 'Τέλος παιχνιδιού';

  @override
  String clearedSub(String difficulty) {
    return 'Ολοκληρώσατε το επίπεδο $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Φτάσατε τα $max λάθη',
      one: 'Φτάσατε τα $max λάθος',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Νέο ρεκόρ';

  @override
  String get time => 'Χρόνος';

  @override
  String get mistakeCount => 'Λάθη';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count φορές',
      one: '$count φορά',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Δυσκολία';

  @override
  String get home => 'Αρχική';

  @override
  String get all => 'Όλα';

  @override
  String get bestRecords => 'Καλύτεροι χρόνοι';

  @override
  String get bestRecordsSub => 'Ταχύτερος χρόνος ανά δυσκολία';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Πρόσφατα παιχνίδια ($count)',
      one: 'Πρόσφατο παιχνίδι ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Δεν υπάρχει ιστορικό ακόμη';

  @override
  String get noRecordsSub => 'Λύστε έναν γρίφο για να εμφανιστεί εδώ';

  @override
  String get clearTime => 'Χρόνος λύσης';

  @override
  String get checkOff => 'Χωρίς έλεγχο';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count λάθη',
      one: '$count λάθος',
    );
    return '$_temp0';
  }

  @override
  String recordDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get clearAll => 'Διαγραφή όλων';

  @override
  String get clearAllTitle => 'Διαγραφή όλου του ιστορικού;';

  @override
  String get clearAllBody => 'Το διαγραμμένο ιστορικό δεν μπορεί να ανακτηθεί.';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get instantCheckDefault => 'Άμεσος έλεγχος από προεπιλογή';

  @override
  String get instantCheckDesc => 'Εμφάνιση λανθασμένων αριθμών αμέσως';

  @override
  String get soundEffects => 'Ηχητικά εφέ';

  @override
  String get soundEffectsDesc => 'Ήχοι εισαγωγής, λάθους και ολοκλήρωσης';

  @override
  String get privacyOptions => 'Επιλογές απορρήτου';

  @override
  String get privacyOptionsDesc =>
      'Ελέγξτε ή αλλάξτε τις ρυθμίσεις συναίνεσης για διαφημίσεις';

  @override
  String get privacyPolicy => 'Πολιτική απορρήτου';

  @override
  String get openLinkFailed => 'Δεν ήταν δυνατό το άνοιγμα του συνδέσμου';

  @override
  String get appVersion => 'Έκδοση εφαρμογής';

  @override
  String get footer => 'Σουντόκου (Sudoku JANG)';

  @override
  String get difficultyEasy => 'Εύκολο';

  @override
  String get difficultyNormal => 'Μέτριο';

  @override
  String get difficultyHard => 'Δύσκολο';

  @override
  String get difficultyExpert => 'Ειδικός';

  @override
  String get difficultyHell => 'Κόλαση';
}
