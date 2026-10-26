// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Rustige focus, een dagelijkse pauze voor je hoofd';

  @override
  String get newGame => 'Nieuw spel';

  @override
  String get records => 'Resultaten';

  @override
  String get settings => 'Instellingen';

  @override
  String get continueTitle => 'Lopend spel';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString voltooid · $time verstreken';
  }

  @override
  String get overwriteTitle => 'Een nieuw spel starten?';

  @override
  String get overwriteBody => 'Je lopende spel gaat verloren.';

  @override
  String get saveIncompatible =>
      'Een opgeslagen spel uit een oudere versie kon niet worden hervat en is verwijderd.';

  @override
  String get cancel => 'Annuleren';

  @override
  String get removeAds => 'Advertenties weg';

  @override
  String removeAdsWithPrice(String price) {
    return 'Advertenties weg $price';
  }

  @override
  String get removeAdsDesc => 'Eén aankoop, voor altijd zonder advertenties';

  @override
  String get removeAdsLongDesc =>
      'Verwijder alle advertenties voorgoed met één aankoop en focus volledig op de puzzel.';

  @override
  String get adsRemoved => 'Advertenties verwijderd';

  @override
  String get purchasePending => 'Bezig';

  @override
  String get storeUnavailable => 'Kan geen verbinding maken met de winkel';

  @override
  String get restorePurchases => 'Aankopen herstellen';

  @override
  String get restoreRequested => 'Je aankoopgeschiedenis wordt gecontroleerd';

  @override
  String get purchaseFailed =>
      'De betaling kon niet worden voltooid. Probeer het later opnieuw';

  @override
  String get restoreFailed =>
      'Aankopen konden niet worden hersteld. Probeer het later opnieuw';

  @override
  String get restoreNone => 'Geen aankopen om te herstellen';

  @override
  String get resultRemoveAdsLine => 'Liever spelen zonder advertenties?';

  @override
  String get chooseDifficulty => 'Kies moeilijkheid';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other:
          'Spel voorbij na $max fouten · Ongedaan maken vermindert fouten niet',
      one: 'Spel voorbij na $max fout · Ongedaan maken vermindert fouten niet',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'We beginnen zo';

  @override
  String get preparingSub => 'Nieuwe puzzel wordt gemaakt…';

  @override
  String get puzzleFailed => 'Kan geen puzzel maken. Probeer het opnieuw';

  @override
  String get back => 'Terug';

  @override
  String get more => 'Meer';

  @override
  String get restartSame => 'Opnieuw beginnen';

  @override
  String get restartConfirmTitle => 'Deze puzzel opnieuw beginnen?';

  @override
  String get restartConfirmBody => 'Je invoer, tijd en fouten worden gewist.';

  @override
  String get instantCheck => 'Direct controleren';

  @override
  String mistakes(int count, int max) {
    return 'Fouten $count/$max';
  }

  @override
  String get undo => 'Ongedaan';

  @override
  String get erase => 'Wissen';

  @override
  String get memo => 'Notities';

  @override
  String get memoOn => 'Notities AAN';

  @override
  String get mistakeKept => 'Ongedaan maken vermindert het aantal fouten niet';

  @override
  String cellEmpty(int row, int column) {
    return 'Rij $row, kolom $column, leeg';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Rij $row, kolom $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, nog $count';
  }

  @override
  String get cleared => 'Opgelost!';

  @override
  String get gameOver => 'Spel voorbij';

  @override
  String clearedSub(String difficulty) {
    return 'Je hebt niveau $difficulty voltooid';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Je hebt $max fouten bereikt',
      one: 'Je hebt $max fout bereikt',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Nieuw record';

  @override
  String get time => 'Tijd';

  @override
  String get mistakeCount => 'Fouten';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count keer',
      one: '$count keer',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Niveau';

  @override
  String get home => 'Start';

  @override
  String get all => 'Alle';

  @override
  String get bestRecords => 'Beste tijden';

  @override
  String get bestRecordsSub => 'Snelste tijd per moeilijkheid';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Recente spellen ($count)',
      one: 'Recent spel ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Nog geen resultaten';

  @override
  String get noRecordsSub => 'Los een puzzel op om die hier te zien';

  @override
  String get clearTime => 'Oplostijd';

  @override
  String get checkOff => 'Geen controle';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fouten',
      one: '$count fout',
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
  String get clearAll => 'Alles wissen';

  @override
  String get clearAllTitle => 'Alle resultaten wissen?';

  @override
  String get clearAllBody => 'Gewiste resultaten kunnen niet worden hersteld.';

  @override
  String get delete => 'Wissen';

  @override
  String get instantCheckDefault => 'Standaard direct controleren';

  @override
  String get instantCheckDesc => 'Toon foute invoer meteen';

  @override
  String get privacyOptions => 'Privacyopties';

  @override
  String get privacyOptionsDesc =>
      'Bekijk of wijzig je instellingen voor advertentietoestemming';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get openLinkFailed => 'Kan de link niet openen';

  @override
  String get appVersion => 'App-versie';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Makkelijk';

  @override
  String get difficultyNormal => 'Gemiddeld';

  @override
  String get difficultyHard => 'Moeilijk';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get difficultyHell => 'Hel';
}
