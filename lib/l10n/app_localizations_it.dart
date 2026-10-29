// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline =>
      'Concentrazione serena, una pausa quotidiana per la mente';

  @override
  String get newGame => 'Nuova partita';

  @override
  String get records => 'Statistiche';

  @override
  String get settings => 'Impostazioni';

  @override
  String get continueTitle => 'Partita in corso';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString completato · $time trascorso';
  }

  @override
  String get overwriteTitle => 'Iniziare una nuova partita?';

  @override
  String get overwriteBody => 'La partita in corso andrà persa.';

  @override
  String get saveIncompatible =>
      'Non è stato possibile riprendere una partita salvata da una versione precedente, quindi è stata eliminata.';

  @override
  String get cancel => 'Annulla';

  @override
  String get removeAds => 'Rimuovi pubblicità';

  @override
  String removeAdsWithPrice(String price) {
    return 'Rimuovi pubblicità $price';
  }

  @override
  String get removeAdsDesc => 'Un solo acquisto, senza pubblicità per sempre';

  @override
  String get removeAdsLongDesc =>
      'Rimuovi per sempre tutta la pubblicità con un solo acquisto e concentrati completamente sul rompicapo.';

  @override
  String get adsRemoved => 'Pubblicità rimossa';

  @override
  String get purchasePending => 'In elaborazione';

  @override
  String get storeUnavailable => 'Impossibile connettersi allo store';

  @override
  String get restorePurchases => 'Ripristina acquisti';

  @override
  String get restoreRequested => 'Verifica degli acquisti in corso';

  @override
  String get purchaseFailed =>
      'Impossibile completare il pagamento. Riprova più tardi';

  @override
  String get restoreFailed =>
      'Impossibile ripristinare gli acquisti. Riprova più tardi';

  @override
  String get restoreNone => 'Nessun acquisto da ripristinare';

  @override
  String get resultRemoveAdsLine => 'Vuoi giocare senza pubblicità?';

  @override
  String get chooseDifficulty => 'Scegli la difficoltà';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Partita finita dopo $max errori · Annulla non riduce gli errori',
      one: 'Partita finita dopo $max errore · Annulla non riduce gli errori',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Si comincia tra poco';

  @override
  String get preparingSub => 'Creazione di un nuovo rompicapo…';

  @override
  String get puzzleFailed => 'Impossibile creare il rompicapo. Riprova';

  @override
  String get back => 'Indietro';

  @override
  String get more => 'Altro';

  @override
  String get restartSame => 'Ricomincia';

  @override
  String get restartConfirmTitle =>
      'Ricominciare questo rompicapo dall\'inizio?';

  @override
  String get restartConfirmBody =>
      'Numeri inseriti, tempo ed errori verranno azzerati.';

  @override
  String get instantCheck => 'Verifica immediata';

  @override
  String mistakes(int count, int max) {
    return 'Errori $count/$max';
  }

  @override
  String get undo => 'Annulla';

  @override
  String get erase => 'Cancella';

  @override
  String get memo => 'Note';

  @override
  String get memoOn => 'Note ON';

  @override
  String get mistakeKept => 'Annullare non riduce il numero di errori';

  @override
  String cellEmpty(int row, int column) {
    return 'Riga $row, colonna $column, vuota';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Riga $row, colonna $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, ne restano $count';
  }

  @override
  String get cleared => 'Risolto!';

  @override
  String get gameOver => 'Partita finita';

  @override
  String clearedSub(String difficulty) {
    return 'Hai completato il livello $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Hai raggiunto $max errori',
      one: 'Hai raggiunto $max errore',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Nuovo record';

  @override
  String get time => 'Tempo';

  @override
  String get mistakeCount => 'Errori';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count volte',
      one: '$count volta',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Difficoltà';

  @override
  String get home => 'Home';

  @override
  String get all => 'Tutte';

  @override
  String get bestRecords => 'Tempi migliori';

  @override
  String get bestRecordsSub => 'Tempo più veloce per difficoltà';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Partite recenti ($count)',
      one: 'Partita recente ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Ancora nessuna partita';

  @override
  String get noRecordsSub => 'Risolvi un rompicapo per vederlo qui';

  @override
  String get clearTime => 'Tempo di soluzione';

  @override
  String get checkOff => 'Senza verifica';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errori',
      one: '$count errore',
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
  String get clearAll => 'Elimina tutto';

  @override
  String get clearAllTitle => 'Eliminare tutte le statistiche?';

  @override
  String get clearAllBody =>
      'Le partite eliminate non possono essere recuperate.';

  @override
  String get delete => 'Elimina';

  @override
  String get instantCheckDefault => 'Verifica immediata predefinita';

  @override
  String get instantCheckDesc => 'Mostra subito gli inserimenti errati';

  @override
  String get soundEffects => 'Effetti sonori';

  @override
  String get soundEffectsDesc => 'Suoni di inserimento, errore e completamento';

  @override
  String get privacyOptions => 'Opzioni privacy';

  @override
  String get privacyOptionsDesc =>
      'Rivedi o modifica le impostazioni del consenso agli annunci';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get openLinkFailed => 'Impossibile aprire il link';

  @override
  String get appVersion => 'Versione app';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyNormal => 'Medio';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String get difficultyExpert => 'Esperto';

  @override
  String get difficultyHell => 'Inferno';

  @override
  String get hint => 'Suggerimento';

  @override
  String get hintUse => 'Usa suggerimento';

  @override
  String get hintRankingWarn =>
      'Usando un suggerimento, questa partita esce dalla classifica della settimana';

  @override
  String get rewardHintTitle => 'Guarda un annuncio per un suggerimento';

  @override
  String get rewardHintBody =>
      'Guarda un breve annuncio fino alla fine per ricevere 1 suggerimento. Domani i suggerimenti gratuiti tornano a 3.';

  @override
  String get rewardContinueBody =>
      'Guarda un breve annuncio fino alla fine per azzerare gli errori e continuare a giocare.';

  @override
  String get watchAd => 'Guarda annuncio';

  @override
  String get adLoading => 'Caricamento annuncio…';

  @override
  String get adUnavailable => 'Impossibile caricare un annuncio ora';

  @override
  String get adNotCompleted =>
      'Guarda l\'annuncio fino alla fine per ricevere il premio';

  @override
  String get continueAfterFail => 'Continua a giocare';

  @override
  String get continueWithAd => 'Guarda annuncio e continua';

  @override
  String get weeklyTitle => 'Sfida settimanale';

  @override
  String weeklyWeekLabel(int week) {
    return 'Settimana $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Fino a $date';
  }

  @override
  String get weeklyRule =>
      'In classifica solo le partite risolte senza suggerimenti';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Risolte $done/$total';
  }

  @override
  String get weeklyChallenge => 'Gioca';

  @override
  String get weeklyRetry => 'Rigioca';

  @override
  String get weeklyNotPlayed => 'Non ancora giocata';

  @override
  String get weeklyInProgress => 'In corso';

  @override
  String get weeklyNoLeader => 'Ancora nessun primo';

  @override
  String get weeklyLoadFailed => 'Impossibile caricare la classifica';

  @override
  String get retry => 'Riprova';

  @override
  String get weeklyYouAreFirst => 'Sei al primo posto!';

  @override
  String weeklyMyBest(String time) {
    return 'Il mio miglior tempo della settimana $time';
  }

  @override
  String get weeklySending =>
      'Invio in corso — verrà completato quando sarai online';

  @override
  String get weeklyRank1 => 'Primo posto questa settimana!';

  @override
  String get weeklyHintExcluded =>
      'Suggerimento usato — fuori classifica questa settimana';

  @override
  String get weeklyLastWeek =>
      'Rompicapo della settimana scorsa — non registrato';

  @override
  String get rankingExcluded => 'Fuori classifica';

  @override
  String get anonymous => 'Anonimo';

  @override
  String get weeklyReport => 'Segnala un nickname';

  @override
  String get nickname => 'Nickname';

  @override
  String get nicknameSet => 'Imposta nickname';

  @override
  String get nicknameChange => 'Cambia';

  @override
  String get nicknameHelper => 'Visibile in classifica';

  @override
  String get nicknameTooShort => 'Usa almeno 2 caratteri';

  @override
  String get nicknameInvalid => 'Solo lettere, numeri, spazi e _';

  @override
  String get nicknameBanned => 'Questo nickname non è consentito';

  @override
  String get save => 'Salva';
}
