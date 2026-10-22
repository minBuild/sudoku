/// 전면광고 노출 간격. 새 게임 시작 시점에만 묻는다. 메모리에만 둔다.
class AdSchedule {
  AdSchedule({DateTime Function()? now, this.interval = defaultInterval})
    : _now = now ?? DateTime.now;

  /// 마지막 노출 후 이 시간이 지나야 다음 새 게임에 광고를 띄운다.
  static const defaultInterval = Duration(minutes: 15);

  final DateTime Function() _now;
  final Duration interval;
  DateTime? _lastShownAt;
  bool _inFlight = false;

  /// 처음이면 true. 시계가 역행해도 true.
  bool get isDue {
    final last = _lastShownAt;
    if (last == null) return true;
    final d = _now().difference(last);
    return d.isNegative || d >= interval;
  }

  /// 광고 판단 슬롯 점유. 진행 중이거나 due 가 아니면 false.
  bool tryClaim() {
    if (_inFlight || !isDue) return false;
    _inFlight = true;
    return true;
  }

  /// tryClaim 이 true 였던 쪽만 부른다. shown 이면 지금 시각을 기록.
  void release({required bool shown}) {
    _inFlight = false;
    if (shown) _lastShownAt = _now();
  }
}
