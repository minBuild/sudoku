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
  String get soundEffects => 'Efeitos sonoros';

  @override
  String get soundEffectsDesc => 'Sons de entrada, erro e conclusão';

  @override
  String get privacyOptions => 'Opções de privacidade';

  @override
  String get privacyOptionsDesc =>
      'Consulte ou altere suas configurações de consentimento de anúncios';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get openLinkFailed => 'Não foi possível abrir o link';

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

  @override
  String get hint => 'Dica';

  @override
  String get hintUse => 'Usar dica';

  @override
  String get hintRankingWarn =>
      'Usar uma dica tira este jogo do ranking desta semana';

  @override
  String get rewardHintTitle => 'Assista a um anúncio e ganhe uma dica';

  @override
  String get rewardHintBody =>
      'Assista a um anúncio curto até o fim para ganhar 1 dica. As dicas grátis voltam a 3 amanhã.';

  @override
  String get rewardContinueBody =>
      'Assista a um anúncio curto até o fim para zerar os erros e continuar jogando.';

  @override
  String get watchAd => 'Ver anúncio';

  @override
  String get adLoading => 'Carregando anúncio…';

  @override
  String get adUnavailable => 'Não é possível carregar um anúncio agora';

  @override
  String get adNotCompleted =>
      'Assista ao anúncio até o fim para receber a recompensa';

  @override
  String get continueAfterFail => 'Continuar jogando';

  @override
  String get continueWithAd => 'Ver anúncio e continuar';

  @override
  String get weeklyTitle => 'Desafio semanal';

  @override
  String weeklyWeekLabel(int week) {
    return 'Semana $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Até $date';
  }

  @override
  String get weeklyRule => 'Só entram no ranking soluções sem dicas';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Resolvidos $done/$total';
  }

  @override
  String get weeklyChallenge => 'Jogar';

  @override
  String get weeklyRetry => 'Jogar de novo';

  @override
  String get weeklyNotPlayed => 'Ainda não jogado';

  @override
  String get weeklyInProgress => 'Em andamento';

  @override
  String get weeklyNoLeader => 'Ainda sem líder';

  @override
  String get weeklyLoadFailed => 'Não foi possível carregar o ranking';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get weeklyYouAreFirst => 'Você é o nº 1!';

  @override
  String weeklyMyBest(String time) {
    return 'Meu melhor tempo nesta semana $time';
  }

  @override
  String get weeklySending =>
      'Enviando — será concluído quando você estiver online';

  @override
  String get weeklyRank1 => 'Nº 1 desta semana!';

  @override
  String get weeklyHintExcluded => 'Dica usada — fora do ranking desta semana';

  @override
  String get weeklyLastWeek =>
      'Quebra-cabeça da semana passada — não registrado';

  @override
  String get rankingExcluded => 'Fora do ranking';

  @override
  String get anonymous => 'Anônimo';

  @override
  String get weeklyReport => 'Denunciar apelido';

  @override
  String get nickname => 'Apelido';

  @override
  String get nicknameSet => 'Definir apelido';

  @override
  String get nicknameChange => 'Alterar';

  @override
  String get nicknameHelper => 'Exibido no ranking';

  @override
  String get nicknameTooShort => 'Use pelo menos 2 caracteres';

  @override
  String get nicknameInvalid => 'Apenas letras, números, espaços e _';

  @override
  String get nicknameBanned => 'Este apelido não é permitido';

  @override
  String get save => 'Salvar';
}
