/// 게임 효과음 종류. `tool/gen_sounds.dart` 가 Flutter 없이 읽으므로 import 를 두지 않는다.
enum SoundCue {
  tap(40),

  /// 숫자를 칸에 적을 때. tap 보다 음정이 또렷한 짧은 "톡".
  place(100),

  /// 메모 숫자를 켤 때. 연필로 짧게 긁는 소리.
  note(140),
  wrong(150),
  failed(400),
  solved(600);

  const SoundCue(this.ms);

  /// 클립 최대 길이. gen_sounds · 에셋 테스트 · stop 예약이 공유한다.
  final int ms;
}
