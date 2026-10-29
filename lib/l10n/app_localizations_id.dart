// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Sudoku';

  @override
  String get appBadge => 'JANG';

  @override
  String get tagline => 'Fokus yang tenang, rehat harian untuk pikiran';

  @override
  String get newGame => 'Game Baru';

  @override
  String get records => 'Riwayat';

  @override
  String get settings => 'Pengaturan';

  @override
  String get continueTitle => 'Game yang sedang berjalan';

  @override
  String continueDetail(double progress, String time) {
    final intl.NumberFormat progressNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String progressString = progressNumberFormat.format(progress);

    return '$progressString selesai · $time berlalu';
  }

  @override
  String get overwriteTitle => 'Mulai game baru?';

  @override
  String get overwriteBody => 'Game yang sedang berjalan akan hilang.';

  @override
  String get saveIncompatible =>
      'Game tersimpan dari versi lama tidak dapat dilanjutkan, jadi telah dihapus.';

  @override
  String get cancel => 'Batal';

  @override
  String get removeAds => 'Hapus Iklan';

  @override
  String removeAdsWithPrice(String price) {
    return 'Hapus Iklan $price';
  }

  @override
  String get removeAdsDesc => 'Sekali beli, bebas iklan selamanya';

  @override
  String get removeAdsLongDesc =>
      'Hapus semua iklan secara permanen dengan sekali pembelian dan fokus sepenuhnya pada teka-teki.';

  @override
  String get adsRemoved => 'Iklan dihapus';

  @override
  String get purchasePending => 'Memproses';

  @override
  String get storeUnavailable => 'Tidak dapat terhubung ke toko';

  @override
  String get restorePurchases => 'Pulihkan Pembelian';

  @override
  String get restoreRequested => 'Memeriksa riwayat pembelian Anda';

  @override
  String get purchaseFailed =>
      'Pembayaran tidak dapat diselesaikan. Coba lagi nanti';

  @override
  String get restoreFailed =>
      'Pembelian tidak dapat dipulihkan. Coba lagi nanti';

  @override
  String get restoreNone => 'Tidak ada pembelian untuk dipulihkan';

  @override
  String get resultRemoveAdsLine => 'Ingin bermain tanpa iklan?';

  @override
  String get chooseDifficulty => 'Pilih Tingkat Kesulitan';

  @override
  String difficultyRule(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other:
          'Game berakhir setelah $max kesalahan · Urungkan tidak mengurangi kesalahan',
    );
    return '$_temp0';
  }

  @override
  String get preparing => 'Segera dimulai';

  @override
  String get preparingSub => 'Membuat teka-teki baru…';

  @override
  String get puzzleFailed => 'Tidak dapat membuat teka-teki. Coba lagi';

  @override
  String get back => 'Kembali';

  @override
  String get more => 'Lainnya';

  @override
  String get restartSame => 'Ulangi Teka-teki';

  @override
  String get restartConfirmTitle => 'Ulangi teka-teki ini dari awal?';

  @override
  String get restartConfirmBody =>
      'Isian, waktu, dan kesalahan akan diatur ulang.';

  @override
  String get instantCheck => 'Cek Langsung';

  @override
  String mistakes(int count, int max) {
    return 'Salah $count/$max';
  }

  @override
  String get undo => 'Urungkan';

  @override
  String get erase => 'Hapus';

  @override
  String get memo => 'Catatan';

  @override
  String get memoOn => 'Catatan AKTIF';

  @override
  String get mistakeKept => 'Urungkan tidak mengurangi jumlah kesalahan';

  @override
  String cellEmpty(int row, int column) {
    return 'Baris $row, kolom $column, kosong';
  }

  @override
  String cellValue(int row, int column, int value) {
    return 'Baris $row, kolom $column, $value';
  }

  @override
  String remainingLabel(int number, int count) {
    return '$number, sisa $count';
  }

  @override
  String get cleared => 'Selesai!';

  @override
  String get gameOver => 'Game Berakhir';

  @override
  String clearedSub(String difficulty) {
    return 'Anda menyelesaikan tingkat $difficulty';
  }

  @override
  String gameOverSub(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Anda mencapai $max kesalahan',
    );
    return '$_temp0';
  }

  @override
  String get newBest => '🏆 Rekor Baru';

  @override
  String get time => 'Waktu';

  @override
  String get mistakeCount => 'Kesalahan';

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
  String get difficulty => 'Tingkat';

  @override
  String get home => 'Beranda';

  @override
  String get all => 'Semua';

  @override
  String get bestRecords => 'Waktu Terbaik';

  @override
  String get bestRecordsSub => 'Waktu tercepat per tingkat kesulitan';

  @override
  String recentRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Riwayat terbaru ($count)',
    );
    return '$_temp0';
  }

  @override
  String get noRecords => 'Belum ada riwayat';

  @override
  String get noRecordsSub => 'Selesaikan teka-teki untuk melihatnya di sini';

  @override
  String get clearTime => 'Waktu Selesai';

  @override
  String get checkOff => 'Tanpa Cek';

  @override
  String recordMistakes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kesalahan',
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
  String get clearAll => 'Hapus Semua';

  @override
  String get clearAllTitle => 'Hapus semua riwayat?';

  @override
  String get clearAllBody => 'Riwayat yang dihapus tidak dapat dipulihkan.';

  @override
  String get delete => 'Hapus';

  @override
  String get instantCheckDefault => 'Cek Langsung secara Default';

  @override
  String get instantCheckDesc => 'Tampilkan isian yang salah saat dimasukkan';

  @override
  String get soundEffects => 'Efek suara';

  @override
  String get soundEffectsDesc => 'Suara input, kesalahan, dan selesai';

  @override
  String get privacyOptions => 'Opsi Privasi';

  @override
  String get privacyOptionsDesc =>
      'Tinjau atau ubah pengaturan persetujuan iklan Anda';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get openLinkFailed => 'Tidak dapat membuka tautan';

  @override
  String get appVersion => 'Versi Aplikasi';

  @override
  String get footer => 'Sudoku JANG';

  @override
  String get difficultyEasy => 'Mudah';

  @override
  String get difficultyNormal => 'Sedang';

  @override
  String get difficultyHard => 'Sulit';

  @override
  String get difficultyExpert => 'Ahli';

  @override
  String get difficultyHell => 'Neraka';

  @override
  String get hint => 'Petunjuk';

  @override
  String get hintUse => 'Pakai petunjuk';

  @override
  String get hintRankingWarn =>
      'Memakai petunjuk membuat game ini tidak masuk peringkat minggu ini';

  @override
  String get rewardHintTitle => 'Tonton iklan untuk petunjuk';

  @override
  String get rewardHintBody =>
      'Tonton iklan singkat sampai selesai untuk mendapat 1 petunjuk. Petunjuk gratis terisi lagi menjadi 3 besok.';

  @override
  String get rewardContinueBody =>
      'Tonton iklan singkat sampai selesai untuk mengatur ulang kesalahan dan lanjut bermain.';

  @override
  String get watchAd => 'Tonton iklan';

  @override
  String get adLoading => 'Memuat iklan…';

  @override
  String get adUnavailable => 'Iklan tidak dapat dimuat sekarang';

  @override
  String get adNotCompleted =>
      'Tonton iklan sampai selesai untuk mendapat hadiah';

  @override
  String get continueAfterFail => 'Lanjut main';

  @override
  String get continueWithAd => 'Tonton iklan untuk lanjut';

  @override
  String get weeklyTitle => 'Tantangan mingguan';

  @override
  String weeklyWeekLabel(int week) {
    return 'Minggu $week';
  }

  @override
  String weeklyEndsAt(String date) {
    return 'Hingga $date';
  }

  @override
  String get weeklyRule =>
      'Hanya penyelesaian tanpa petunjuk yang masuk peringkat';

  @override
  String weeklyClearedCount(int done, int total) {
    return 'Selesai $done/$total';
  }

  @override
  String get weeklyChallenge => 'Main';

  @override
  String get weeklyRetry => 'Main lagi';

  @override
  String get weeklyNotPlayed => 'Belum dimainkan';

  @override
  String get weeklyInProgress => 'Berlangsung';

  @override
  String get weeklyNoLeader => 'Belum ada juara';

  @override
  String get weeklyLoadFailed => 'Gagal memuat peringkat';

  @override
  String get retry => 'Coba lagi';

  @override
  String get weeklyYouAreFirst => 'Anda peringkat 1!';

  @override
  String weeklyMyBest(String time) {
    return 'Waktu terbaik saya minggu ini $time';
  }

  @override
  String get weeklySending => 'Mengirim — akan selesai saat Anda online';

  @override
  String get weeklyRank1 => 'Peringkat 1 minggu ini!';

  @override
  String get weeklyHintExcluded =>
      'Petunjuk dipakai — tidak masuk peringkat minggu ini';

  @override
  String get weeklyLastWeek => 'Teka-teki minggu lalu — tidak dicatat';

  @override
  String get rankingExcluded => 'Tanpa peringkat';

  @override
  String get anonymous => 'Anonim';

  @override
  String get weeklyReport => 'Laporkan nama panggilan';

  @override
  String get nickname => 'Nama panggilan';

  @override
  String get nicknameSet => 'Atur nama panggilan';

  @override
  String get nicknameChange => 'Ubah';

  @override
  String get nicknameHelper => 'Ditampilkan di papan peringkat';

  @override
  String get nicknameTooShort => 'Gunakan minimal 2 karakter';

  @override
  String get nicknameInvalid => 'Hanya huruf, angka, spasi, dan _';

  @override
  String get nicknameBanned => 'Nama panggilan ini tidak diizinkan';

  @override
  String get save => 'Simpan';
}
