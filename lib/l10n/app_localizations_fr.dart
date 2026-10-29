// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline =>
      'Une concentration sereine, une pause quotidienne pour l\'esprit';

  @override
  String get newGame => 'Nouvelle partie';

  @override
  String get records => 'Historique';

  @override
  String get settings => 'Paramètres';

  @override
  String get continueTitle => 'Partie en cours';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString terminé · $time écoulé';
  }

  @override
  String get overwriteTitle => 'Commencer une nouvelle partie ?';

  @override
  String get overwriteBody => 'La partie en cours sera perdue.';

  @override
  String get saveIncompatible =>
      'La partie enregistrée d\'une ancienne version ne pouvait pas être reprise et a été supprimée.';

  @override
  String get cancel => 'Annuler';

  @override
  String get removeAds => 'Supprimer les pubs';

  @override
  String removeAdsWithPrice(String price) {
    return 'Supprimer les pubs $price';
  }

  @override
  String get removeAdsDesc => 'Un seul achat, sans pub pour toujours';

  @override
  String get removeAdsLongDesc =>
      'Supprimez définitivement toutes les publicités en un seul achat et concentrez-vous pleinement sur le puzzle.';

  @override
  String get adsRemoved => 'Pubs supprimées';

  @override
  String get purchasePending => 'En cours';

  @override
  String get storeUnavailable => 'Impossible de se connecter à la boutique';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get restoreRequested => 'Vérification de vos achats';

  @override
  String get purchaseFailed =>
      'Le paiement n\'a pas pu aboutir. Veuillez réessayer plus tard';

  @override
  String get restoreFailed =>
      'Impossible de restaurer les achats. Veuillez réessayer plus tard';

  @override
  String get restoreNone => 'Aucun achat à restaurer';

  @override
  String get resultRemoveAdsLine => 'Envie de jouer sans pub ?';

  @override
  String get chooseDifficulty => 'Choisir la difficulté';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other:
          'Partie terminée après $max erreurs · Annuler ne réduit pas les erreurs',
      one:
          'Partie terminée après $max erreur · Annuler ne réduit pas les erreurs',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'La partie va commencer';

  @override
  String get preparingSub => 'Création d\'un nouveau puzzle…';

  @override
  String get puzzleFailed =>
      'Impossible de créer le puzzle. Veuillez réessayer';

  @override
  String get back => 'Retour';

  @override
  String get more => 'Plus';

  @override
  String get restartSame => 'Recommencer';

  @override
  String get restartConfirmTitle => 'Recommencer ce puzzle depuis le début ?';

  @override
  String get restartConfirmBody =>
      'Les chiffres saisis, le temps et les erreurs seront réinitialisés.';

  @override
  String get instantCheck => 'Vérification immédiate';

  @override
  String mistakes(int count, int max) {
    return 'Erreurs $count/$max';
  }

  @override
  String get undo => 'Annuler';

  @override
  String get erase => 'Effacer';

  @override
  String get memo => 'Notes';

  @override
  String get memoOn => 'Notes actives';

  @override
  String get mistakeKept => 'Annuler ne réduit pas le nombre d\'erreurs';

  @override
  String cellEmpty(int row, int column) {
    return 'Ligne $row, colonne $column, vide';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Ligne $row, colonne $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, reste $count';
  }

  @override
  String get cleared => 'Réussi !';

  @override
  String get gameOver => 'Partie terminée';

  @override
  String clearedSub(String difficulty) {
    return 'Vous avez terminé le niveau $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Vous avez atteint $max erreurs',
      one: 'Vous avez atteint $max erreur',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Nouveau record';

  @override
  String get time => 'Temps';

  @override
  String get mistakeCount => 'Erreurs';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fois',
      one: '$count fois',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Difficulté';

  @override
  String get home => 'Accueil';

  @override
  String get all => 'Tous';

  @override
  String get bestRecords => 'Meilleurs temps';

  @override
  String get bestRecordsSub => 'Temps le plus rapide par difficulté';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Parties récentes ($count)',
      one: 'Partie récente ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Aucune partie pour l\'instant';

  @override
  String get noRecordsSub => 'Terminez un puzzle pour le voir ici';

  @override
  String get clearTime => 'Temps de résolution';

  @override
  String get checkOff => 'Sans vérif.';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count erreurs',
      one: '$count erreur',
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
  String get clearAll => 'Tout supprimer';

  @override
  String get clearAllTitle => 'Supprimer tout l\'historique ?';

  @override
  String get clearAllBody =>
      'Les parties supprimées ne peuvent pas être récupérées.';

  @override
  String get delete => 'Supprimer';

  @override
  String get instantCheckDefault => 'Vérification immédiate par défaut';

  @override
  String get instantCheckDesc => 'Signale une erreur dès sa saisie';

  @override
  String get soundEffects => 'Effets sonores';

  @override
  String get soundEffectsDesc => 'Sons de saisie, d\'erreur et de réussite';

  @override
  String get privacyOptions => 'Options de confidentialité';

  @override
  String get privacyOptionsDesc =>
      'Consultez ou modifiez vos paramètres de consentement publicitaire';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get openLinkFailed => 'Impossible d\'ouvrir le lien';

  @override
  String get appVersion => 'Version de l\'app';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyNormal => 'Moyen';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get difficultyHell => 'Enfer';

  @override
  String get hint => 'Indice';

  @override
  String get hintUse => 'Utiliser un indice';

  @override
  String get hintRankingWarn =>
      'Utiliser un indice retire cette partie du classement de la semaine';

  @override
  String get rewardHintTitle => 'Regarder une pub pour un indice';

  @override
  String get rewardHintBody =>
      'Regardez une courte pub jusqu\'au bout pour obtenir 1 indice. Vos indices gratuits reviennent à 3 demain.';

  @override
  String get rewardContinueBody =>
      'Regardez une courte pub jusqu\'au bout pour remettre les erreurs à zéro et continuer.';

  @override
  String get watchAd => 'Voir la pub';

  @override
  String get adLoading => 'Chargement de la pub…';

  @override
  String get adUnavailable => 'Impossible de charger une pub pour l\'instant';

  @override
  String get adNotCompleted =>
      'Regardez la pub jusqu\'au bout pour obtenir la récompense';

  @override
  String get continueAfterFail => 'Continuer';

  @override
  String get continueWithAd => 'Voir une pub et continuer';

  @override
  String get weeklyTitle => 'Défi de la semaine';

  @override
  String weeklyWeekLabel(int week) {
    return 'Semaine $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Jusqu\'au $date';
  }

  @override
  String get weeklyRule => 'Seules les parties sans indice sont classées';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Terminées $done/$total';
  }

  @override
  String get weeklyChallenge => 'Jouer';

  @override
  String get weeklyRetry => 'Rejouer';

  @override
  String get weeklyNotPlayed => 'Pas encore joué';

  @override
  String get weeklyInProgress => 'En cours';

  @override
  String get weeklyNoLeader => 'Pas encore de premier';

  @override
  String get weeklyLoadFailed => 'Impossible de charger le classement';

  @override
  String get retry => 'Réessayer';

  @override
  String get weeklyYouAreFirst => 'Vous êtes n° 1 !';

  @override
  String weeklyMyBest(String time) {
    return 'Mon record de la semaine $time';
  }

  @override
  String get weeklySending =>
      'Envoi en cours — finalisé dès que vous serez en ligne';

  @override
  String get weeklyRank1 => 'N° 1 cette semaine !';

  @override
  String get weeklyHintExcluded => 'Indice utilisé — non classé cette semaine';

  @override
  String get weeklyLastWeek => 'Puzzle de la semaine dernière — non enregistré';

  @override
  String get rankingExcluded => 'Non classé';

  @override
  String get anonymous => 'Anonyme';

  @override
  String get weeklyReport => 'Signaler un pseudo';

  @override
  String get nickname => 'Pseudo';

  @override
  String get nicknameSet => 'Choisir un pseudo';

  @override
  String get nicknameChange => 'Modifier';

  @override
  String get nicknameHelper => 'Visible dans le classement';

  @override
  String get nicknameTooShort => 'Au moins 2 caractères';

  @override
  String get nicknameInvalid => 'Lettres, chiffres, espaces et _ uniquement';

  @override
  String get nicknameBanned => 'Ce pseudo n\'est pas autorisé';

  @override
  String get save => 'Enregistrer';
}
