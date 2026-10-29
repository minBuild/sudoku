/// 게임 효과음 종류. `tool/gen_sounds.dart` 가 Flutter 없이 읽으므로 import 를 두지 않는다.
enum SoundCue {
  tap(40),
  wrong(150),
  failed(400),
  solved(600);

  const SoundCue(this.ms);

  /// 클립 최대 길이. gen_sounds · 에셋 테스트 · stop 예약이 공유한다.
  final int ms;
}
