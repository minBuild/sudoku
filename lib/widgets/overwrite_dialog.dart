import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

/// 진행 중인 게임을 덮어쓸지 묻는다. 홈과 주간 화면이 함께 쓴다.
Future<bool> confirmOverwrite(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(context.l10n.overwriteTitle),
      content: Text(context.l10n.overwriteBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(context.l10n.newGame),
        ),
      ],
    ),
  );
  return ok == true;
}
