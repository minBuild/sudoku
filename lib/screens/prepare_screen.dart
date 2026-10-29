import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_deps.dart';
import '../flows/game_launcher.dart';
import '../l10n/l10n.dart';
import '../models/difficulty.dart';
import '../services/purchase/purchase_service.dart';
import '../services/weekly/weekly_board.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';

/// 광고 게이트. 생성 ∥ 광고가 끝나면 GameScreen 으로 교체한다.
/// 닫기(X)로 나가면 화면 전환은 하지 않고, 주간 퍼즐 캐시 저장만 끝까지 진행된다 (W25).
class PrepareScreen extends StatefulWidget {
  const PrepareScreen({super.key, required this.difficulty, this.weekly});

  final Difficulty difficulty;

  /// 주간 판이면 그 보드의 시드 퍼즐을 만든다.
  final WeeklyBoard? weekly;

  @override
  State<PrepareScreen> createState() => _PrepareScreenState();
}

class _PrepareScreenState extends State<PrepareScreen> {
  late final AppDeps _deps = context.read<AppDeps>();

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    final d = widget.difficulty;
    final launcher = GameLauncher(
      generate: _deps.generate,
      ads: _deps.ads,
      adsRemoved: _deps.entitlement.adsRemoved,
      schedule: _deps.adSchedule,
    );
    try {
      final r = await launcher.prepare(d, weekly: widget.weekly);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        gameRoute(
          GameSeed.fresh(
            r.puzzle,
            d,
            _deps.settings.instantCheckDefault,
            weeklyBoard: widget.weekly?.id,
          ),
        ),
      );
    } catch (e) {
      // ParallelWaitError 포함. 광고가 떠 있었다면 이미 닫힌 뒤다 (D6).
      debugPrint('PrepareScreen: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.puzzleFailed)));
      Navigator.pop(context);
    }
  }

  void _buy() {
    _deps.ads.cancelPending(); // 표시 중이면 효과 없음 (D4)
    _deps.purchase.buy();
  }

  @override
  void dispose() {
    _deps.ads.cancelPending();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppTheme.maxContentWidth,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.pagePadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppLogo(),
                        const SizedBox(height: 40),
                        const SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            strokeCap: StrokeCap.round,
                            backgroundColor: AppTheme.primaryTint,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          context.l10n.preparing,
                          textAlign: TextAlign.center,
                          style: text.headlineSmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.l10n.preparingSub,
                          textAlign: TextAlign.center,
                          style: text.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 48),
                        _RemoveAdsButton(onPressed: _buy),
                      ],
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                top: 4,
                start: 4,
                child: IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.close_rounded),
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 미구매자이고 Ready 일 때만 보인다.
class _RemoveAdsButton extends StatelessWidget {
  const _RemoveAdsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final deps = context.read<AppDeps>();
    return ValueListenableBuilder<bool>(
      valueListenable: deps.entitlement.adsRemoved,
      builder: (context, removed, _) => removed
          ? const SizedBox.shrink()
          : ValueListenableBuilder<PurchaseUiState>(
              valueListenable: deps.purchase.state,
              builder: (context, state, _) => state is PurchaseReady
                  ? FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primaryTint,
                        foregroundColor: AppTheme.primary,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: onPressed,
                      icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                      label: Text(context.l10n.removeAdsWithPrice(state.price)),
                    )
                  : const SizedBox.shrink(),
            ),
    );
  }
}
