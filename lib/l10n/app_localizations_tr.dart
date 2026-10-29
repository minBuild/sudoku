// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Sakin bir odak, zihniniz için günlük bir mola';

  @override
  String get newGame => 'Yeni Oyun';

  @override
  String get records => 'Kayıtlar';

  @override
  String get settings => 'Ayarlar';

  @override
  String get continueTitle => 'Devam eden oyun';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString tamamlandı · $time geçti';
  }

  @override
  String get overwriteTitle => 'Yeni oyun başlatılsın mı?';

  @override
  String get overwriteBody => 'Devam eden oyununuz kaybolacak.';

  @override
  String get saveIncompatible =>
      'Eski bir sürümden kaydedilen oyun sürdürülemediği için silindi.';

  @override
  String get cancel => 'İptal';

  @override
  String get removeAds => 'Reklamları Kaldır';

  @override
  String removeAdsWithPrice(String price) {
    return 'Reklamları Kaldır $price';
  }

  @override
  String get removeAdsDesc => 'Tek satın alma, sonsuza dek reklamsız';

  @override
  String get removeAdsLongDesc =>
      'Tek bir satın alma ile tüm reklamları kalıcı olarak kaldırın ve bulmacaya tamamen odaklanın.';

  @override
  String get adsRemoved => 'Reklamlar kaldırıldı';

  @override
  String get purchasePending => 'İşleniyor';

  @override
  String get storeUnavailable => 'Mağazaya bağlanılamıyor';

  @override
  String get restorePurchases => 'Satın Alımları Geri Yükle';

  @override
  String get restoreRequested => 'Satın alma geçmişiniz kontrol ediliyor';

  @override
  String get purchaseFailed =>
      'Ödeme tamamlanamadı. Lütfen daha sonra tekrar deneyin';

  @override
  String get restoreFailed =>
      'Satın alımlar geri yüklenemedi. Lütfen daha sonra tekrar deneyin';

  @override
  String get restoreNone => 'Geri yüklenecek satın alım yok';

  @override
  String get resultRemoveAdsLine => 'Reklamsız oynamak ister misiniz?';

  @override
  String get chooseDifficulty => 'Zorluk Seçin';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: '$max hatada oyun biter · Geri al hataları azaltmaz',
      one: '$max hatada oyun biter · Geri al hataları azaltmaz',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Birazdan başlıyor';

  @override
  String get preparingSub => 'Yeni bulmaca oluşturuluyor…';

  @override
  String get puzzleFailed => 'Bulmaca oluşturulamadı. Lütfen tekrar deneyin';

  @override
  String get back => 'Geri';

  @override
  String get more => 'Diğer';

  @override
  String get restartSame => 'Yeniden Başlat';

  @override
  String get restartConfirmTitle => 'Bu bulmaca baştan başlatılsın mı?';

  @override
  String get restartConfirmBody =>
      'Girdiğiniz sayılar, süre ve hatalar sıfırlanacak.';

  @override
  String get instantCheck => 'Anında Kontrol';

  @override
  String mistakes(int count, int max) {
    return 'Hata $count/$max';
  }

  @override
  String get undo => 'Geri Al';

  @override
  String get erase => 'Sil';

  @override
  String get memo => 'Not';

  @override
  String get memoOn => 'Not AÇIK';

  @override
  String get mistakeKept => 'Geri almak hata sayısını azaltmaz';

  @override
  String cellEmpty(int row, int column) {
    return 'Satır $row, sütun $column, boş';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Satır $row, sütun $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, $count kaldı';
  }

  @override
  String get cleared => 'Çözüldü!';

  @override
  String get gameOver => 'Oyun Bitti';

  @override
  String clearedSub(String difficulty) {
    return '$difficulty seviyesini tamamladınız';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: '$max hataya ulaştınız',
      one: '$max hataya ulaştınız',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Yeni Rekor';

  @override
  String get time => 'Süre';

  @override
  String get mistakeCount => 'Hata';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kez',
      one: '$count kez',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Zorluk';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get all => 'Tümü';

  @override
  String get bestRecords => 'En İyi Süreler';

  @override
  String get bestRecordsSub => 'Her zorlukta en hızlı süre';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Son kayıtlar ($count)',
      one: 'Son kayıt ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Henüz kayıt yok';

  @override
  String get noRecordsSub => 'Burada görmek için bir bulmaca çözün';

  @override
  String get clearTime => 'Çözüm Süresi';

  @override
  String get checkOff => 'Kontrolsüz';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hata',
      one: '$count hata',
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
  String get clearAll => 'Tümünü Sil';

  @override
  String get clearAllTitle => 'Tüm kayıtlar silinsin mi?';

  @override
  String get clearAllBody => 'Silinen kayıtlar geri getirilemez.';

  @override
  String get delete => 'Sil';

  @override
  String get instantCheckDefault => 'Varsayılan Olarak Anında Kontrol';

  @override
  String get instantCheckDesc => 'Yanlış girişleri girer girmez göster';

  @override
  String get soundEffects => 'Ses efektleri';

  @override
  String get soundEffectsDesc => 'Giriş, hata ve tamamlama sesleri';

  @override
  String get privacyOptions => 'Gizlilik Seçenekleri';

  @override
  String get privacyOptionsDesc =>
      'Reklam izni ayarlarınızı inceleyin veya değiştirin';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get openLinkFailed => 'Bağlantı açılamadı';

  @override
  String get appVersion => 'Uygulama Sürümü';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Kolay';

  @override
  String get difficultyNormal => 'Orta';

  @override
  String get difficultyHard => 'Zor';

  @override
  String get difficultyExpert => 'Uzman';

  @override
  String get difficultyHell => 'Cehennem';

  @override
  String get hint => 'İpucu';

  @override
  String get hintUse => 'İpucu kullan';

  @override
  String get hintRankingWarn =>
      'İpucu kullanırsanız bu oyun bu haftaki sıralamaya girmez';

  @override
  String get rewardHintTitle => 'İpucu için reklam izleyin';

  @override
  String get rewardHintBody =>
      'Kısa bir reklamı sonuna kadar izleyin ve 1 ipucu kazanın. Ücretsiz ipuçları yarın yeniden 3 olur.';

  @override
  String get rewardContinueBody =>
      'Kısa bir reklamı sonuna kadar izleyerek hataları sıfırlayın ve oynamaya devam edin.';

  @override
  String get watchAd => 'Reklam izle';

  @override
  String get adLoading => 'Reklam yükleniyor…';

  @override
  String get adUnavailable => 'Şu anda reklam yüklenemiyor';

  @override
  String get adNotCompleted => 'Ödülü almak için reklamı sonuna kadar izleyin';

  @override
  String get continueAfterFail => 'Devam et';

  @override
  String get continueWithAd => 'Reklam izle ve devam et';

  @override
  String get weeklyTitle => 'Haftalık meydan okuma';

  @override
  String weeklyWeekLabel(int week) {
    return '$week. hafta';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Bitiş: $date';
  }

  @override
  String get weeklyRule => 'Yalnızca ipucusuz çözümler sıralamaya girer';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Çözülen $done/$total';
  }

  @override
  String get weeklyChallenge => 'Oyna';

  @override
  String get weeklyRetry => 'Tekrar oyna';

  @override
  String get weeklyNotPlayed => 'Henüz oynanmadı';

  @override
  String get weeklyInProgress => 'Devam ediyor';

  @override
  String get weeklyNoLeader => 'Henüz lider yok';

  @override
  String get weeklyLoadFailed => 'Sıralama yüklenemedi';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get weeklyYouAreFirst => 'Birincisiniz!';

  @override
  String weeklyMyBest(String time) {
    return 'Bu haftaki en iyi sürem $time';
  }

  @override
  String get weeklySending => 'Gönderiliyor — çevrimiçi olunca tamamlanır';

  @override
  String get weeklyRank1 => 'Bu hafta birinci!';

  @override
  String get weeklyHintExcluded => 'İpucu kullanıldı — bu hafta sıralama dışı';

  @override
  String get weeklyLastWeek => 'Geçen haftanın bulmacası — kaydedilmedi';

  @override
  String get rankingExcluded => 'Sıralama dışı';

  @override
  String get anonymous => 'Anonim';

  @override
  String get weeklyReport => 'Takma adı bildir';

  @override
  String get nickname => 'Takma ad';

  @override
  String get nicknameSet => 'Takma ad belirle';

  @override
  String get nicknameChange => 'Değiştir';

  @override
  String get nicknameHelper => 'Sıralamada gösterilir';

  @override
  String get nicknameTooShort => 'En az 2 karakter kullanın';

  @override
  String get nicknameInvalid => 'Yalnızca harf, rakam, boşluk ve _';

  @override
  String get nicknameBanned => 'Bu takma ada izin verilmiyor';

  @override
  String get save => 'Kaydet';
}
