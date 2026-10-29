import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/weekly/nickname.dart';
import '../services/weekly/weekly_service.dart';

/// 공개 닉네임 입력. 수정할 때는 기존 값을 미리 채운다.
class NicknameDialog extends StatefulWidget {
  const NicknameDialog({super.key, required this.service});

  final WeeklyService service;

  /// 저장에 성공하면 닫힌다. 에러가 나면 닫지 않고 문구를 보여 준다.
  static Future<void> showAndSave(
    BuildContext context,
    WeeklyService service,
  ) => showDialog<void>(
    context: context,
    builder: (_) => NicknameDialog(service: service),
  );

  @override
  State<NicknameDialog> createState() => _NicknameDialogState();
}

class _NicknameDialogState extends State<NicknameDialog> {
  late final _text = TextEditingController(text: widget.service.store.nick);
  NicknameError? _error;
  bool _saving = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final err = await widget.service.setNickname(_text.text);
    if (!mounted) return;
    if (err == null) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      _saving = false;
      _error = err;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final errorText = switch (_error) {
      null => null,
      NicknameError.tooShort => l10n.nicknameTooShort,
      // 12자는 maxLength 가 막는다. 남는 경우는 결합 문자 남용(UTF-16 초과)이다.
      NicknameError.tooLong ||
      NicknameError.invalidChars => l10n.nicknameInvalid,
      NicknameError.banned => l10n.nicknameBanned,
    };
    return AlertDialog(
      title: Text(l10n.nickname),
      content: TextField(
        controller: _text,
        maxLength: Nickname.maxLength,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _save(),
        onChanged: (_) {
          if (_error != null) setState(() => _error = null);
        },
        decoration: InputDecoration(
          helperText: l10n.nicknameHelper,
          errorText: errorText,
          errorMaxLines: 2,
          helperMaxLines: 2,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _saving ? null : _save, child: Text(l10n.save)),
      ],
    );
  }
}
