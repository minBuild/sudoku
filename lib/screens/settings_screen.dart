import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app.dart';
import '../app_deps.dart';
import '../l10n/l10n.dart';
import '../services/purchase/purchase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/nickname_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final AppDeps _deps = context.read<AppDeps>();
  late bool _instantCheck = _deps.settings.instantCheckDefault;
  late bool _sound = _deps.settings.soundEnabled;

  void _restore() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.restoreRequested)));
    _deps.purchase.restore();
  }

  bool _opening = false;

  // 연타 방지. 열지 못하면 스낵바로 알린다.
  Future<void> _open(Uri u) async {
    if (_opening) return;
    _opening = true;
    try {
      final ok = await _deps.openUrl(u);
      if (!ok && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.openLinkFailed)));
      }
    } finally {
      _opening = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppTheme.maxContentWidth),
          child: ListView(
            padding: const EdgeInsets.all(AppTheme.pagePadding),
            children: [
              _RemoveAdsSection(onRestore: _restore),
              const SizedBox(height: 16),
              Container(
                decoration: AppTheme.card(),
                clipBehavior: Clip.antiAlias,
                child: Material(
                  color: Colors.transparent,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _deps.entitlement.adsRemoved,
                    builder: (context, removed, _) {
                      final showPrivacy =
                          !removed && _deps.ads.privacyOptionsRequired;
                      return Column(
                        children: [
                          SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 4,
                            ),
                            title: Text(
                              context.l10n.instantCheckDefault,
                              style: text.titleMedium,
                            ),
                            subtitle: Text(
                              context.l10n.instantCheckDesc,
                              style: text.bodySmall,
                            ),
                            value: _instantCheck,
                            onChanged: (v) {
                              setState(() => _instantCheck = v);
                              _deps.settings.setInstantCheckDefault(v);
                            },
                          ),
                          const Divider(indent: 20, endIndent: 20),
                          SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 4,
                            ),
                            title: Text(
                              context.l10n.soundEffects,
                              style: text.titleMedium,
                            ),
                            subtitle: Text(
                              context.l10n.soundEffectsDesc,
                              style: text.bodySmall,
                            ),
                            value: _sound,
                            onChanged: (v) {
                              setState(() => _sound = v);
                              _deps.settings.setSoundEnabled(v);
                            },
                          ),
                          if (_deps.weekly case final w?) ...[
                            const Divider(indent: 20, endIndent: 20),
                            ValueListenableBuilder<int>(
                              valueListenable: w.store.changes,
                              builder: (context, _, _) => ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                title: Text(
                                  context.l10n.nickname,
                                  style: text.titleMedium,
                                ),
                                subtitle: Text(
                                  w.store.nick ?? context.l10n.anonymous,
                                  style: text.bodySmall,
                                ),
                                trailing: Text(
                                  w.store.nick == null
                                      ? context.l10n.nicknameSet
                                      : context.l10n.nicknameChange,
                                  style: text.labelLarge?.copyWith(
                                    color: AppTheme.primary,
                                  ),
                                ),
                                onTap: () =>
                                    NicknameDialog.showAndSave(context, w),
                              ),
                            ),
                          ],
                          if (showPrivacy) ...[
                            const Divider(indent: 20, endIndent: 20),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              title: Text(
                                context.l10n.privacyOptions,
                                style: text.titleMedium,
                              ),
                              subtitle: Text(
                                context.l10n.privacyOptionsDesc,
                                style: text.bodySmall,
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded),
                              onTap: _deps.ads.showPrivacyOptionsForm,
                            ),
                          ],
                          if (_deps.privacyPolicyUri case final u?) ...[
                            const Divider(indent: 20, endIndent: 20),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              title: Text(
                                context.l10n.privacyPolicy,
                                style: text.titleMedium,
                              ),
                              trailing: const Icon(Icons.open_in_new_rounded),
                              onTap: () => _open(u),
                            ),
                          ],
                          const Divider(indent: 20, endIndent: 20),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            title: Text(
                              context.l10n.appVersion,
                              style: text.titleMedium,
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryTint,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Text(
                                'v$appVersion',
                                style: text.labelSmall?.copyWith(
                                  color: AppTheme.primary,
                                  fontFeatures: AppTheme.tabular,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.footer,
                textAlign: TextAlign.center,
                style: text.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RemoveAdsSection extends StatelessWidget {
  const _RemoveAdsSection({required this.onRestore});

  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final deps = context.read<AppDeps>();
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.removeAds, style: text.headlineSmall),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.removeAdsLongDesc,
                      style: text.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<PurchaseUiState>(
            valueListenable: deps.purchase.state,
            builder: (context, state, _) => switch (state) {
              PurchaseReady(:final price) => FilledButton(
                onPressed: deps.purchase.buy,
                child: Text(context.l10n.removeAdsWithPrice(price)),
              ),
              PurchasePending() => FilledButton(
                onPressed: null,
                child: Text(context.l10n.purchasePending),
              ),
              PurchaseOwned() => FilledButton.icon(
                onPressed: null,
                icon: const Icon(Icons.check_rounded),
                label: Text(context.l10n.adsRemoved),
              ),
              PurchaseUnavailable() => FilledButton(
                onPressed: null,
                child: Text(context.l10n.storeUnavailable),
              ),
              PurchaseLoading() => FilledButton(
                onPressed: null,
                child: Text(context.l10n.removeAds),
              ),
            },
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryTint,
              foregroundColor: AppTheme.primary,
            ),
            onPressed: onRestore,
            child: Text(context.l10n.restorePurchases),
          ),
        ],
      ),
    );
  }
}
