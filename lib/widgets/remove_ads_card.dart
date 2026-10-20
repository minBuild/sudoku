import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/strings.dart';
import '../services/purchase/entitlement_store.dart';
import '../services/purchase/purchase_service.dart';
import '../theme/app_theme.dart';

/// 홈 하단 광고 제거 카드. 권리가 있으면 그리지 않는다.
class RemoveAdsCard extends StatelessWidget {
  const RemoveAdsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final entitlement = context.read<EntitlementStore>();
    final purchase = context.read<PurchaseGateway>();
    return ValueListenableBuilder<bool>(
      valueListenable: entitlement.adsRemoved,
      builder: (context, removed, _) {
        if (removed) return const SizedBox.shrink();
        return ValueListenableBuilder<PurchaseUiState>(
          valueListenable: purchase.state,
          builder: (context, state, _) {
            final text = Theme.of(context).textTheme;
            final ready = state is PurchaseReady;
            final pending = state is PurchasePending;
            return Container(
              key: const ValueKey('remove-ads-card'),
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.card(),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_outlined,
                              size: 18,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(S.removeAds, style: text.titleMedium),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(S.removeAdsDesc, style: text.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: FilledButton(
                      onPressed: ready ? purchase.buy : null,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          ready
                              ? S.removeAdsWithPrice(state.price)
                              : pending
                              ? S.purchasePending
                              : S.removeAds,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
