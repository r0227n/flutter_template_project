# Flutter Coding Guidelines

Flutterの開発におけるガイドラインをここに定義する。

## Dart 3 / Flutter 3.x 対応ガイドライン

### Riverpod: Switch-Case パターンマッチング

Dart 3のパターンマッチング機能を活用し、AsyncValueでswitch-case構文を使用します。

#### 基本的なパターン

```dart
// switch-case構文を使用（推奨）
switch (asyncValue) {
  case AsyncData(:final value):
    return Text(value.toString());
  case AsyncError(:final error):
    return Text('Error: $error');
  case _:
    return const CircularProgressIndicator();
}

// 従来のwhen/map構文（非推奨）
asyncValue.when(
  data: (value) => Text(value.toString()),
  error: (error, stack) => Text('Error: $error'),
  loading: () => const CircularProgressIndicator(),
);
```

#### 高度な使用例

**skipLoadingOnReload: true相当**

```dart
switch (asyncValue) {
  case AsyncValue(:final error?):
    return Text('Error: $error');
  case AsyncValue(:final value, hasData: true):
    return Text(value.toString());
  case _:
    return const CircularProgressIndicator();
}
```

**skipError: true相当**

```dart
switch (asyncValue) {
  case AsyncValue(:final value, hasData: true, isReloading: false):
    return Text(value.toString());
  case AsyncValue(:final error?):
    return Text('Error: $error');
  case _:
    return const CircularProgressIndicator();
}
```

### Freezed: sealed/abstract キーワード

Dart 3では、Freezedクラスで`sealed`または`abstract`キーワードを使用します。

#### 単一クラス

```dart
// abstractキーワードを使用（推奨）
@freezed
abstract class Person with _$Person {
  const factory Person({
    required String name,
    required int age,
  }) = _Person;
}

// キーワードなし（非推奨）
@freezed
class Person with _$Person {
  const factory Person({
    required String name,
    required int age,
  }) = _Person;
}
```

#### マルチバリアントクラス

```dart
// sealedキーワードを使用（推奨）
@freezed
sealed class Result with _$Result {
  const factory Result.success(String data) = Success;
  const factory Result.error(String message) = Error;
}

// キーワードなし（非推奨）
@freezed
class Result with _$Result {
  const factory Result.success(String data) = Success;
  const factory Result.error(String message) = Error;
}
```

#### パターンマッチング

```dart
// switch-case構文を使用（推奨）
final message = switch (result) {
  Success(:final data) => 'Success: $data',
  Error(:final message) => 'Error: $message',
};

// 従来のmap構文（非推奨）
final message = result.map(
  success: (data) => 'Success: ${data.data}',
  error: (error) => 'Error: ${error.message}',
);
```

### Row/Column Spacing（Flutter 3.27+）

Flutter 3.27以降では、Row/Columnウィジェットでspacingプロパティを使用します。

#### spacingプロパティを使用（推奨）

```dart
Row(
  spacing: 16,
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
)
```

#### SizedBoxを使用（非推奨）

```dart
Row(
  children: [
    Text('Item 1'),
    SizedBox(width: 16),
    Text('Item 2'),
    SizedBox(width: 16),
    Text('Item 3'),
  ],
)
```

#### Columnでの使用例

```dart
Column(
  spacing: 8,
  children: [
    Card(child: ListTile(title: Text('Item 1'))),
    Card(child: ListTile(title: Text('Item 2'))),
    Card(child: ListTile(title: Text('Item 3'))),
  ],
)
```

### ウィジェット作成: Classes vs Functions

再利用可能なウィジェットを作成する際は、ClassベースのStatelessWidget/StatefulWidgetを使用します。

#### Classベースのウィジェット（推奨）

```dart
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
  });

  final String text;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(text),
    );
  }
}
```

#### Functionベースのウィジェット（非推奨）

```dart
Widget customButton({
  required String text,
  required VoidCallback onPressed,
  Color color = Colors.blue,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(backgroundColor: color),
    child: Text(text),
  );
}
```

#### なぜClassベースが推奨されるのか

**1. パフォーマンス**

- Flutterの最適化機能（Widget rebuild最適化）が適用される
- constコンストラクタによる不要な再描画を防止
- Element tree上での効率的な比較が可能

**2. デバッグ性**

- Flutter Inspector でウィジェット階層が正しく表示される
- Hot Reload時の状態保持が適切に動作
- デバッグ時にウィジェット名が明確に識別される

**3. メンテナンス性**

- プロパティの型安全性が保証される
- IDEでの自動補完とリファクタリング支援
- ドキュメンテーションとの統合が容易

**4. Flutter Framework との統合**

- Theme、MediaQuery等のContext依存処理が適切に動作
- ウィジェットライフサイクルの管理が正しく行われる
- テスト時のウィジェット特定が容易

#### 使い分けのガイドライン

**Classを使用する場合（推奨）**

- 再利用可能なUI コンポーネント
- プロパティを持つウィジェット
- 複雑なレイアウト構造
- 状態管理が必要な場合

**Functionを使用する場合（限定的）**

- 単純な内部的なヘルパー（build内でのみ使用）
- 一時的なコード分割（後でClassに移行予定）
- パフォーマンスが重要でない使い捨てコード

```dart
class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ✅ 良い例：Classベースのウィジェット
          CustomButton(
            text: 'Submit',
            onPressed: () => _submit(),
          ),

          // ❌ 避ける例：Functionベースのウィジェット
          customButton(
            text: 'Cancel',
            onPressed: () => _cancel(),
          ),

          // ✅ 許可される例：内部的なヘルパー
          _buildHeader(),
        ],
      ),
    );
  }

  // 内部的なヘルパー（このページでのみ使用）
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text('Header'),
    );
  }
}
```

## コーディング推奨事項チェックリスト

- [ ] AsyncValueでswitch-case構文を使用
- [ ] Freezedクラスでsealed/abstractキーワードを使用
- [ ] Row/Columnでspacingプロパティを使用
- [ ] パターンマッチングで非網羅的switchに対応
- [ ] 再利用可能なウィジェットはClassベースで作成

## Containerと SizedBox or DecoratedBox 使い分け

| 項目                | Container                                                                   | SizedBox                                                  | DecoratedBox                                             |
| ------------------- | --------------------------------------------------------------------------- | --------------------------------------------------------- | -------------------------------------------------------- |
| 目的                | レイアウト、スタイリング、サイズ指定を統合する多機能ウィジェット            | サイズの固定、または固定された空間の確保                  | 装飾の描画（背景、ボーダー、シャドウなど）に特化         |
| 内部構造            | 複数の軽量ウィジェット（ConstrainedBox, DecoratedBoxなど）の組み合わせ      | 単純なウィジェットであり、内部的なコンポジションは最小限  | 単純なウィジェットであり、内部的なコンポジションは最小限 |
| 利用可能プロパティ  | child, width, height, padding, margin, color, decoration, alignmentなど多数 | child, width, heightのみ                                  | child, decoration, positionのみ                          |
| パフォーマンス      | 多機能ゆえに、単一目的での使用時にはオーバーヘッドが発生する可能性          | サイズ固定に特化しているため、最も軽量                    | 装飾に特化しており、軽量                                 |
| constコンストラクタ | プロパティが渡されると利用不可となる場合が多い                              | 利用可能                                                  | 利用可能                                                 |
| 典型的ユースケース  | 複数のレイアウトプロパティを同時に制御するUIカードなど                      | ウィジェット間の余白、特定のサイズの固定                  | 背景色、グラデーション、ボーダー、シャドウの適用         |
| 子のない場合の挙動  | 親の制約によっては、利用可能なすべての空間を占有する可能性がある            | widthとheightが指定されていない場合、幅と高さはゼロになる | childがなければ何も描画されない                          |

## 参考サイト

- [Add a page showcasing how to migrate from AsyncValue.map/when to Dart 3's switch-case](https://github.com/rrousselGit/riverpod/issues/2715)
- [freezed Require keyword (sealed / abstract)](https://github.com/rrousselGit/freezed/blob/master/packages/freezed/migration_guide.md)
- [Spacing Argument in Row/Column](https://codewithandrea.com/tips/spacing-row-column/)
- [Functions Vs Classes To Create Reusable Widgets](https://medium.com/@abdurrehman-520/functions-vs-classes-to-create-reusable-widgets-in-flutter-2cf0678ea39a)
