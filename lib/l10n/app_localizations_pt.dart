// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Foco tranquilo, uma pausa diária para a mente';

  @override
  String get newGame => 'Novo jogo';

  @override
  String get records => 'Recordes';

  @override
  String get settings => 'Configurações';

  @override
  String get continueTitle => 'Jogo em andamento';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString concluído · $time decorrido';
  }

  @override
  String get overwriteTitle => 'Começar um novo jogo?';

  @override
  String get overwriteBody => 'O jogo em andamento será perdido.';

  @override
  String get saveIncompatible =>
      'O jogo salvo de uma versão anterior não podia ser retomado e foi excluído.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get removeAds => 'Remover anúncios';

  @override
  String removeAdsWithPrice(String price) {
    return 'Remover anúncios $price';
  }

  @override
  String get removeAdsDesc => 'Uma única compra, sem anúncios para sempre';

  @override
  String get removeAdsLongDesc =>
      'Remova todos os anúncios para sempre com uma única compra e concentre-se totalmente no quebra-cabeça.';

  @override
  String get adsRemoved => 'Anúncios removidos';

  @override
  String get purchasePending => 'Processando';

  @override
  String get storeUnavailable => 'Não foi possível conectar à loja';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get restoreRequested => 'Verificando suas compras';

  @override
  String get purchaseFailed =>
      'Não foi possível concluir o pagamento. Tente novamente mais tarde';

  @override
  String get restoreFailed =>
      'Não foi possível restaurar as compras. Tente novamente mais tarde';

  @override
  String get restoreNone => 'Não há compras para restaurar';

  @override
  String get resultRemoveAdsLine => 'Quer jogar sem anúncios?';

  @override
  String get chooseDifficulty => 'Escolher dificuldade';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Fim de jogo com $max erros · Desfazer não reduz os erros',
      one: 'Fim de jogo com $max erro · Desfazer não reduz os erros',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Começando em instantes';

  @override
  String get preparingSub => 'Gerando um novo quebra-cabeça…';

  @override
  String get puzzleFailed =>
      'Não foi possível criar o quebra-cabeça. Tente novamente';

  @override
  String get back => 'Voltar';

  @override
  String get more => 'Mais';

  @override
  String get restartSame => 'Reiniciar jogo';

  @override
  String get restartConfirmTitle => 'Reiniciar este quebra-cabeça do início?';

  @override
  String get restartConfirmBody =>
      'Os números, o tempo e os erros serão redefinidos.';

  @override
  String get instantCheck => 'Verificação imediata';

  @override
  String mistakes(int count, int max) {
    return 'Erros $count/$max';
  }

  @override
  String get undo => 'Desfazer';

  @override
  String get erase => 'Apagar';

  @override
  String get memo => 'Notas';

  @override
  String get memoOn => 'Notas ativas';

  @override
  String get mistakeKept => 'Desfazer não reduz o número de erros';

  @override
  String cellEmpty(int row, int column) {
    return 'Linha $row, coluna $column, vazia';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Linha $row, coluna $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, restam $count';
  }

  @override
  String get cleared => 'Resolvido!';

  @override
  String get gameOver => 'Fim de jogo';

  @override
  String clearedSub(String difficulty) {
    return 'Você concluiu o nível $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Você chegou a $max erros',
      one: 'Você chegou a $max erro',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Novo recorde';

  @override
  String get time => 'Tempo';

  @override
  String get mistakeCount => 'Erros';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vezes',
      one: '$count vez',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Dificuldade';

  @override
  String get home => 'Início';

  @override
  String get all => 'Todos';

  @override
  String get bestRecords => 'Melhores tempos';

  @override
  String get bestRecordsSub => 'Tempo mais rápido por dificuldade';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Recordes recentes ($count)',
      one: 'Recorde recente ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Ainda não há recordes';

  @override
  String get noRecordsSub => 'Resolva um quebra-cabeça para vê-lo aqui';

  @override
  String get clearTime => 'Tempo de resolução';

  @override
  String get checkOff => 'Sem verificação';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count erros',
      one: '$count erro',
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
  String get clearAll => 'Excluir tudo';

  @override
  String get clearAllTitle => 'Excluir todos os recordes?';

  @override
  String get clearAllBody => 'Os recordes excluídos não podem ser recuperados.';

  @override
  String get delete => 'Excluir';

  @override
  String get instantCheckDefault => 'Verificação imediata por padrão';

  @override
  String get instantCheckDesc => 'Mostra os erros assim que você os digita';

  @override
  String get privacyOptions => 'Opções de privacidade';

  @override
  String get privacyOptionsDesc =>
      'Consulte ou altere suas configurações de consentimento de anúncios';

  @override
  String get appVersion => 'Versão do app';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get difficultyExpert => 'Especialista';

  @override
  String get difficultyHell => 'Inferno';
}
