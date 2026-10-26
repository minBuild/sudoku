// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Concentrare liniștită, o pauză zilnică pentru minte';

  @override
  String get newGame => 'Joc nou';

  @override
  String get records => 'Istoric';

  @override
  String get settings => 'Setări';

  @override
  String get continueTitle => 'Joc în desfășurare';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString completat · $time scurs';
  }

  @override
  String get overwriteTitle => 'Începi un joc nou?';

  @override
  String get overwriteBody => 'Jocul în desfășurare se va pierde.';

  @override
  String get saveIncompatible =>
      'Un joc salvat dintr-o versiune mai veche nu a putut fi reluat, așa că a fost șters.';

  @override
  String get cancel => 'Anulează';

  @override
  String get removeAds => 'Elimină reclamele';

  @override
  String removeAdsWithPrice(String price) {
    return 'Elimină reclamele $price';
  }

  @override
  String get removeAdsDesc =>
      'O singură achiziție, fără reclame pentru totdeauna';

  @override
  String get removeAdsLongDesc =>
      'Elimină definitiv toate reclamele cu o singură achiziție și concentrează-te pe deplin asupra jocului.';

  @override
  String get adsRemoved => 'Reclame eliminate';

  @override
  String get purchasePending => 'Se procesează';

  @override
  String get storeUnavailable => 'Nu se poate conecta la magazin';

  @override
  String get restorePurchases => 'Restabilește achizițiile';

  @override
  String get restoreRequested => 'Se verifică istoricul achizițiilor';

  @override
  String get purchaseFailed =>
      'Plata nu a putut fi finalizată. Încearcă din nou mai târziu';

  @override
  String get restoreFailed =>
      'Achizițiile nu au putut fi restabilite. Încearcă din nou mai târziu';

  @override
  String get restoreNone => 'Nu există achiziții de restabilit';

  @override
  String get resultRemoveAdsLine => 'Vrei să joci fără reclame?';

  @override
  String get chooseDifficulty => 'Alege dificultatea';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other:
          'Jocul se termină după $max de greșeli · Anularea nu reduce greșelile',
      few: 'Jocul se termină după $max greșeli · Anularea nu reduce greșelile',
      one: 'Jocul se termină după $max greșeală · Anularea nu reduce greșelile',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Începem imediat';

  @override
  String get preparingSub => 'Se generează un joc nou…';

  @override
  String get puzzleFailed => 'Nu s-a putut crea jocul. Încearcă din nou';

  @override
  String get back => 'Înapoi';

  @override
  String get more => 'Mai mult';

  @override
  String get restartSame => 'Reia jocul';

  @override
  String get restartConfirmTitle => 'Reiei acest joc de la început?';

  @override
  String get restartConfirmBody =>
      'Cifrele introduse, timpul și greșelile vor fi resetate.';

  @override
  String get instantCheck => 'Verificare imediată';

  @override
  String mistakes(int count, int max) {
    return 'Greșeli $count/$max';
  }

  @override
  String get undo => 'Anulează';

  @override
  String get erase => 'Șterge';

  @override
  String get memo => 'Notițe';

  @override
  String get memoOn => 'Notițe ACTIV';

  @override
  String get mistakeKept => 'Anularea nu reduce numărul de greșeli';

  @override
  String cellEmpty(int row, int column) {
    return 'Rândul $row, coloana $column, gol';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Rândul $row, coloana $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, au rămas $count';
  }

  @override
  String get cleared => 'Rezolvat!';

  @override
  String get gameOver => 'Joc terminat';

  @override
  String clearedSub(String difficulty) {
    return 'Ai terminat nivelul $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Ai ajuns la $max de greșeli',
      few: 'Ai ajuns la $max greșeli',
      one: 'Ai ajuns la $max greșeală',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Record nou';

  @override
  String get time => 'Timp';

  @override
  String get mistakeCount => 'Greșeli';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de ori',
      few: '$count ori',
      one: '$count dată',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Nivel';

  @override
  String get home => 'Acasă';

  @override
  String get all => 'Toate';

  @override
  String get bestRecords => 'Cei mai buni timpi';

  @override
  String get bestRecordsSub => 'Cel mai rapid timp pe dificultate';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jocuri recente ($count)',
      few: 'Jocuri recente ($count)',
      one: 'Joc recent ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Încă nu există jocuri';

  @override
  String get noRecordsSub => 'Rezolvă un joc ca să-l vezi aici';

  @override
  String get clearTime => 'Timp de rezolvare';

  @override
  String get checkOff => 'Fără verificare';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de greșeli',
      few: '$count greșeli',
      one: '$count greșeală',
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
  String get clearAll => 'Șterge tot';

  @override
  String get clearAllTitle => 'Ștergi tot istoricul?';

  @override
  String get clearAllBody => 'Jocurile șterse nu pot fi recuperate.';

  @override
  String get delete => 'Șterge';

  @override
  String get instantCheckDefault => 'Verificare imediată implicit';

  @override
  String get instantCheckDesc => 'Arată imediat cifrele greșite';

  @override
  String get privacyOptions => 'Opțiuni de confidențialitate';

  @override
  String get privacyOptionsDesc =>
      'Verifică sau modifică setările de consimțământ pentru reclame';

  @override
  String get privacyPolicy => 'Politica de confidențialitate';

  @override
  String get openLinkFailed => 'Linkul nu a putut fi deschis';

  @override
  String get appVersion => 'Versiunea aplicației';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Ușor';

  @override
  String get difficultyNormal => 'Mediu';

  @override
  String get difficultyHard => 'Greu';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get difficultyHell => 'Infern';
}
