// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Spokojne skupienie, codzienna przerwa dla umysłu';

  @override
  String get newGame => 'Nowa gra';

  @override
  String get records => 'Wyniki';

  @override
  String get settings => 'Ustawienia';

  @override
  String get continueTitle => 'Gra w toku';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return 'Ukończono $progressString · minęło $time';
  }

  @override
  String get overwriteTitle => 'Rozpocząć nową grę?';

  @override
  String get overwriteBody => 'Gra w toku zostanie utracona.';

  @override
  String get saveIncompatible =>
      'Zapisanej gry ze starszej wersji nie dało się wznowić, więc została usunięta.';

  @override
  String get cancel => 'Anuluj';

  @override
  String get removeAds => 'Usuń reklamy';

  @override
  String removeAdsWithPrice(String price) {
    return 'Usuń reklamy $price';
  }

  @override
  String get removeAdsDesc => 'Jeden zakup, na zawsze bez reklam';

  @override
  String get removeAdsLongDesc =>
      'Usuń wszystkie reklamy na zawsze jednym zakupem i w pełni skup się na łamigłówce.';

  @override
  String get adsRemoved => 'Reklamy usunięte';

  @override
  String get purchasePending => 'Przetwarzanie';

  @override
  String get storeUnavailable => 'Nie można połączyć się ze sklepem';

  @override
  String get restorePurchases => 'Przywróć zakupy';

  @override
  String get restoreRequested => 'Sprawdzamy historię zakupów';

  @override
  String get purchaseFailed =>
      'Nie udało się dokończyć płatności. Spróbuj ponownie później';

  @override
  String get restoreFailed =>
      'Nie udało się przywrócić zakupów. Spróbuj ponownie później';

  @override
  String get restoreNone => 'Brak zakupów do przywrócenia';

  @override
  String get resultRemoveAdsLine => 'Chcesz grać bez reklam?';

  @override
  String get chooseDifficulty => 'Wybierz poziom trudności';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Koniec gry po $max błędach · Cofnij nie zmniejsza liczby błędów',
      many: 'Koniec gry po $max błędach · Cofnij nie zmniejsza liczby błędów',
      few: 'Koniec gry po $max błędach · Cofnij nie zmniejsza liczby błędów',
      one: 'Koniec gry po $max błędzie · Cofnij nie zmniejsza liczby błędów',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Za chwilę zaczynamy';

  @override
  String get preparingSub => 'Tworzymy nową łamigłówkę…';

  @override
  String get puzzleFailed =>
      'Nie udało się utworzyć łamigłówki. Spróbuj ponownie';

  @override
  String get back => 'Wstecz';

  @override
  String get more => 'Więcej';

  @override
  String get restartSame => 'Od nowa';

  @override
  String get restartConfirmTitle => 'Zacząć tę łamigłówkę od nowa?';

  @override
  String get restartConfirmBody =>
      'Wpisane cyfry, czas i błędy zostaną wyzerowane.';

  @override
  String get instantCheck => 'Natychmiastowe sprawdzanie';

  @override
  String mistakes(int count, int max) {
    return 'Błędy $count/$max';
  }

  @override
  String get undo => 'Cofnij';

  @override
  String get erase => 'Wymaż';

  @override
  String get memo => 'Notatki';

  @override
  String get memoOn => 'Notatki WŁ.';

  @override
  String get mistakeKept => 'Cofnięcie nie zmniejsza liczby błędów';

  @override
  String cellEmpty(int row, int column) {
    return 'Wiersz $row, kolumna $column, puste';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Wiersz $row, kolumna $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, zostało $count';
  }

  @override
  String get cleared => 'Rozwiązane!';

  @override
  String get gameOver => 'Koniec gry';

  @override
  String clearedSub(String difficulty) {
    return 'Ukończono poziom $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Osiągnięto $max błędu',
      many: 'Osiągnięto $max błędów',
      few: 'Osiągnięto $max błędy',
      one: 'Osiągnięto $max błąd',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Nowy rekord';

  @override
  String get time => 'Czas';

  @override
  String get mistakeCount => 'Błędy';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count razy',
      many: '$count razy',
      few: '$count razy',
      one: '$count raz',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Poziom';

  @override
  String get home => 'Start';

  @override
  String get all => 'Wszystkie';

  @override
  String get bestRecords => 'Najlepsze czasy';

  @override
  String get bestRecordsSub => 'Najszybszy czas dla każdego poziomu';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ostatnie gry ($count)',
      many: 'Ostatnie gry ($count)',
      few: 'Ostatnie gry ($count)',
      one: 'Ostatnia gra ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Brak wyników';

  @override
  String get noRecordsSub => 'Rozwiąż łamigłówkę, aby zobaczyć ją tutaj';

  @override
  String get clearTime => 'Czas rozwiązania';

  @override
  String get checkOff => 'Bez sprawdz.';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count błędu',
      many: '$count błędów',
      few: '$count błędy',
      one: '$count błąd',
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
  String get clearAll => 'Usuń wszystko';

  @override
  String get clearAllTitle => 'Usunąć wszystkie wyniki?';

  @override
  String get clearAllBody => 'Usuniętych wyników nie można przywrócić.';

  @override
  String get delete => 'Usuń';

  @override
  String get instantCheckDefault => 'Domyślnie natychmiastowe sprawdzanie';

  @override
  String get instantCheckDesc => 'Pokazuj błędne wpisy od razu';

  @override
  String get soundEffects => 'Efekty dźwiękowe';

  @override
  String get soundEffectsDesc => 'Dźwięki wpisywania, błędu i ukończenia';

  @override
  String get privacyOptions => 'Opcje prywatności';

  @override
  String get privacyOptionsDesc =>
      'Sprawdź lub zmień ustawienia zgody na reklamy';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get openLinkFailed => 'Nie można otworzyć linku';

  @override
  String get appVersion => 'Wersja aplikacji';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Łatwy';

  @override
  String get difficultyNormal => 'Średni';

  @override
  String get difficultyHard => 'Trudny';

  @override
  String get difficultyExpert => 'Ekspert';

  @override
  String get difficultyHell => 'Piekło';

  @override
  String get hint => 'Podpowiedź';

  @override
  String get hintUse => 'Użyj podpowiedzi';

  @override
  String get hintRankingWarn =>
      'Użycie podpowiedzi wyklucza tę grę z rankingu tego tygodnia';

  @override
  String get rewardHintTitle => 'Obejrzyj reklamę, by dostać podpowiedź';

  @override
  String get rewardHintBody =>
      'Obejrzyj krótką reklamę do końca, aby dostać 1 podpowiedź. Jutro znów będziesz mieć 3 darmowe podpowiedzi.';

  @override
  String get rewardContinueBody =>
      'Obejrzyj krótką reklamę do końca, aby wyzerować błędy i grać dalej.';

  @override
  String get watchAd => 'Obejrzyj reklamę';

  @override
  String get adLoading => 'Ładowanie reklamy…';

  @override
  String get adUnavailable => 'Nie można teraz załadować reklamy';

  @override
  String get adNotCompleted =>
      'Obejrzyj reklamę do końca, aby otrzymać nagrodę';

  @override
  String get continueAfterFail => 'Graj dalej';

  @override
  String get continueWithAd => 'Obejrzyj reklamę i graj dalej';

  @override
  String get weeklyTitle => 'Wyzwanie tygodnia';

  @override
  String weeklyWeekLabel(int week) {
    return 'Tydzień $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Do $date';
  }

  @override
  String get weeklyRule =>
      'W rankingu liczą się tylko rozwiązania bez podpowiedzi';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Ukończone $done/$total';
  }

  @override
  String get weeklyChallenge => 'Graj';

  @override
  String get weeklyRetry => 'Zagraj ponownie';

  @override
  String get weeklyNotPlayed => 'Jeszcze nie zagrano';

  @override
  String get weeklyInProgress => 'W toku';

  @override
  String get weeklyNoLeader => 'Jeszcze brak lidera';

  @override
  String get weeklyLoadFailed => 'Nie udało się wczytać rankingu';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get weeklyYouAreFirst => 'Jesteś nr 1!';

  @override
  String weeklyMyBest(String time) {
    return 'Mój najlepszy czas w tym tygodniu $time';
  }

  @override
  String get weeklySending => 'Wysyłanie — zakończy się, gdy będziesz online';

  @override
  String get weeklyRank1 => 'Nr 1 w tym tygodniu!';

  @override
  String get weeklyHintExcluded =>
      'Użyto podpowiedzi — poza rankingiem w tym tygodniu';

  @override
  String get weeklyLastWeek => 'Łamigłówka z zeszłego tygodnia — nie zapisano';

  @override
  String get rankingExcluded => 'Poza rankingiem';

  @override
  String get anonymous => 'Anonim';

  @override
  String get weeklyReport => 'Zgłoś pseudonim';

  @override
  String get nickname => 'Pseudonim';

  @override
  String get nicknameSet => 'Ustaw pseudonim';

  @override
  String get nicknameChange => 'Zmień';

  @override
  String get nicknameHelper => 'Widoczny w rankingu';

  @override
  String get nicknameTooShort => 'Wpisz co najmniej 2 znaki';

  @override
  String get nicknameInvalid => 'Tylko litery, cyfry, spacje i _';

  @override
  String get nicknameBanned => 'Ten pseudonim jest niedozwolony';

  @override
  String get save => 'Zapisz';
}
