import 'package:flutter/material.dart';

/// 設定値をスクロール可能な選択ダイアログで編集する。
class SettingsSelectionTile<T> extends StatelessWidget {
  /// 選択肢の表示名は呼び出し元で翻訳する。
  const SettingsSelectionTile({
    required this.title,
    required this.value,
    required this.options,
    required this.onSelected,
    this.enabled = true,
    super.key,
  });

  /// 設定の項目名。
  final String title;

  /// 保存に成功した現在値。
  final T value;

  /// 値とユーザーに表示するラベルの対応。
  final Map<T, String> options;

  /// 変更した値を保存する callback。
  final ValueChanged<T> onSelected;

  /// 保存中は操作を無効にする。
  final bool enabled;

  Future<void> _select(BuildContext context) async {
    final selected = await showDialog<T>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(title),
        children: [
          RadioGroup<T>(
            groupValue: value,
            onChanged: (selected) => Navigator.pop(context, selected),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in options.entries)
                  RadioListTile<T>(
                    title: Text(option.value),
                    value: option.key,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (context.mounted && selected != null && selected != value) {
      onSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(title),
    subtitle: Text(options[value] ?? ''),
    trailing: const Icon(Icons.chevron_right),
    enabled: enabled,
    onTap: () => _select(context),
  );
}
