// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Fokus yang tenang, rehat harian untuk minda';

  @override
  String get newGame => 'Permainan Baharu';

  @override
  String get records => 'Rekod';

  @override
  String get settings => 'Tetapan';

  @override
  String get continueTitle => 'Permainan sedang berjalan';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString selesai · $time berlalu';
  }

  @override
  String get overwriteTitle => 'Mulakan permainan baharu?';

  @override
  String get overwriteBody => 'Permainan yang sedang berjalan akan hilang.';

  @override
  String get saveIncompatible =>
      'Permainan disimpan daripada versi lama tidak dapat disambung, jadi ia telah dipadamkan.';

  @override
  String get cancel => 'Batal';

  @override
  String get removeAds => 'Buang Iklan';

  @override
  String removeAdsWithPrice(String price) {
    return 'Buang Iklan $price';
  }

  @override
  String get removeAdsDesc => 'Sekali beli, tanpa iklan selama-lamanya';

  @override
  String get removeAdsLongDesc =>
      'Buang semua iklan secara kekal dengan satu pembelian dan fokus sepenuhnya pada teka-teki.';

  @override
  String get adsRemoved => 'Iklan dibuang';

  @override
  String get purchasePending => 'Memproses';

  @override
  String get storeUnavailable => 'Tidak dapat menyambung ke kedai';

  @override
  String get restorePurchases => 'Pulihkan Pembelian';

  @override
  String get restoreRequested => 'Menyemak sejarah pembelian anda';

  @override
  String get purchaseFailed =>
      'Pembayaran tidak dapat diselesaikan. Sila cuba lagi nanti';

  @override
  String get restoreFailed =>
      'Pembelian tidak dapat dipulihkan. Sila cuba lagi nanti';

  @override
  String get restoreNone => 'Tiada pembelian untuk dipulihkan';

  @override
  String get resultRemoveAdsLine => 'Mahu bermain tanpa iklan?';

  @override
  String get chooseDifficulty => 'Pilih Tahap Kesukaran';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other:
          'Permainan tamat selepas $max kesilapan · Buat asal tidak mengurangkan kesilapan',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Akan bermula sebentar lagi';

  @override
  String get preparingSub => 'Menjana teka-teki baharu…';

  @override
  String get puzzleFailed => 'Tidak dapat mencipta teka-teki. Sila cuba lagi';

  @override
  String get back => 'Kembali';

  @override
  String get more => 'Lagi';

  @override
  String get restartSame => 'Mula Semula';

  @override
  String get restartConfirmTitle => 'Mulakan semula teka-teki ini dari awal?';

  @override
  String get restartConfirmBody =>
      'Nombor yang diisi, masa dan kesilapan akan ditetapkan semula.';

  @override
  String get instantCheck => 'Semak Serta-merta';

  @override
  String mistakes(int count, int max) {
    return 'Silap $count/$max';
  }

  @override
  String get undo => 'Buat asal';

  @override
  String get erase => 'Padam';

  @override
  String get memo => 'Nota';

  @override
  String get memoOn => 'Nota HIDUP';

  @override
  String get mistakeKept => 'Buat asal tidak mengurangkan bilangan kesilapan';

  @override
  String cellEmpty(int row, int column) {
    return 'Baris $row, lajur $column, kosong';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Baris $row, lajur $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, tinggal $count';
  }

  @override
  String get cleared => 'Selesai!';

  @override
  String get gameOver => 'Permainan Tamat';

  @override
  String clearedSub(String difficulty) {
    return 'Anda telah menamatkan tahap $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Anda mencapai $max kesilapan',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Rekod Baharu';

  @override
  String get time => 'Masa';

  @override
  String get mistakeCount => 'Kesilapan';

  @override
  String mistakeTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kali',
    );
    return '$_temp0';
  }

  @override
  String get difficulty => 'Tahap';

  @override
  String get home => 'Utama';

  @override
  String get all => 'Semua';

  @override
  String get bestRecords => 'Masa Terbaik';

  @override
  String get bestRecordsSub => 'Masa terpantas bagi setiap tahap';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rekod terkini ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Belum ada rekod';

  @override
  String get noRecordsSub => 'Selesaikan teka-teki untuk melihatnya di sini';

  @override
  String get clearTime => 'Masa Selesai';

  @override
  String get checkOff => 'Tanpa Semak';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kesilapan',
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
  String get clearAll => 'Padam Semua';

  @override
  String get clearAllTitle => 'Padamkan semua rekod?';

  @override
  String get clearAllBody => 'Rekod yang dipadam tidak boleh dipulihkan.';

  @override
  String get delete => 'Padam';

  @override
  String get instantCheckDefault => 'Semak Serta-merta secara Lalai';

  @override
  String get instantCheckDesc =>
      'Tunjukkan isian salah sebaik sahaja dimasukkan';

  @override
  String get soundEffects => 'Kesan bunyi';

  @override
  String get soundEffectsDesc => 'Bunyi input, kesilapan dan selesai';

  @override
  String get privacyOptions => 'Pilihan Privasi';

  @override
  String get privacyOptionsDesc =>
      'Semak atau tukar tetapan persetujuan iklan anda';

  @override
  String get privacyPolicy => 'Dasar Privasi';

  @override
  String get openLinkFailed => 'Tidak dapat membuka pautan';

  @override
  String get appVersion => 'Versi Apl';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Mudah';

  @override
  String get difficultyNormal => 'Sederhana';

  @override
  String get difficultyHard => 'Sukar';

  @override
  String get difficultyExpert => 'Pakar';

  @override
  String get difficultyHell => 'Neraka';

  @override
  String get hint => 'Petunjuk';

  @override
  String get hintUse => 'Guna petunjuk';

  @override
  String get hintRankingWarn =>
      'Menggunakan petunjuk mengecualikan permainan ini daripada kedudukan minggu ini';

  @override
  String get rewardHintTitle => 'Tonton iklan untuk petunjuk';

  @override
  String get rewardHintBody =>
      'Tonton iklan pendek hingga habis untuk mendapat 1 petunjuk. Petunjuk percuma akan diisi semula kepada 3 esok.';

  @override
  String get rewardContinueBody =>
      'Tonton iklan pendek hingga habis untuk menetapkan semula kesilapan dan terus bermain.';

  @override
  String get watchAd => 'Tonton iklan';

  @override
  String get adLoading => 'Memuatkan iklan…';

  @override
  String get adUnavailable => 'Iklan tidak dapat dimuatkan sekarang';

  @override
  String get adNotCompleted =>
      'Tonton iklan hingga habis untuk mendapat ganjaran';

  @override
  String get continueAfterFail => 'Teruskan bermain';

  @override
  String get continueWithAd => 'Tonton iklan untuk teruskan';

  @override
  String get weeklyTitle => 'Cabaran mingguan';

  @override
  String weeklyWeekLabel(int week) {
    return 'Minggu $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Sehingga $date';
  }

  @override
  String get weeklyRule => 'Hanya penyelesaian tanpa petunjuk disenaraikan';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Selesai $done/$total';
  }

  @override
  String get weeklyChallenge => 'Main';

  @override
  String get weeklyRetry => 'Main semula';

  @override
  String get weeklyNotPlayed => 'Belum dimainkan';

  @override
  String get weeklyInProgress => 'Sedang berjalan';

  @override
  String get weeklyNoLeader => 'Belum ada juara';

  @override
  String get weeklyLoadFailed => 'Gagal memuatkan kedudukan';

  @override
  String get retry => 'Cuba lagi';

  @override
  String get weeklyYouAreFirst => 'Anda nombor 1!';

  @override
  String weeklyMyBest(String time) {
    return 'Masa terbaik saya minggu ini $time';
  }

  @override
  String get weeklySending =>
      'Menghantar — akan selesai apabila anda dalam talian';

  @override
  String get weeklyRank1 => 'Nombor 1 minggu ini!';

  @override
  String get weeklyHintExcluded =>
      'Petunjuk digunakan — tiada kedudukan minggu ini';

  @override
  String get weeklyLastWeek => 'Teka-teki minggu lepas — tidak direkodkan';

  @override
  String get rankingExcluded => 'Tiada kedudukan';

  @override
  String get anonymous => 'Tanpa nama';

  @override
  String get weeklyReport => 'Laporkan nama samaran';

  @override
  String get nickname => 'Nama samaran';

  @override
  String get nicknameSet => 'Tetapkan nama samaran';

  @override
  String get nicknameChange => 'Tukar';

  @override
  String get nicknameHelper => 'Dipaparkan pada papan pendahulu';

  @override
  String get nicknameTooShort => 'Gunakan sekurang-kurangnya 2 aksara';

  @override
  String get nicknameInvalid => 'Huruf, nombor, ruang dan _ sahaja';

  @override
  String get nicknameBanned => 'Nama samaran ini tidak dibenarkan';

  @override
  String get save => 'Simpan';
}
