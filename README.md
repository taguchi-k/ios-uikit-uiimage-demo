# UIImage

## 概要
UIImageは、アプリ内の画像データを管理するクラスです。

## 関連クラス
NSObject
　
## 実装手順
1. StoryboardにUIImageViewを配置します。
2. UIViewControllerとStoryboardのUIImageViewを関連付けます。
3. UIViewControllerでUIImageオブジェクトを生成します。
4. UIViewControllerでUIImageオブジェクトを編集します。
5. UIImageViewにUIImageオブジェクトをセットして画面に表示させます。

## 主要プロパティ

|プロパティ名|説明|サンプル|
|---|---|---|
|imageOrientation | 画像の向きの情報を取得する | image.imageOrientation |
|size | 画像のサイズを取得する | image else |
|scale | 画像のスケールを取得する | image.scale |

## 主要メソッド

|メソッド名|説明|サンプル|
|---|---|---|
|draw(in:) | 指定した範囲内に画像全体を描画する <br> 必要に応じてサイズを変更しフィットさせる | image.draw(in: CGRect(x: 0, y: 0, width: 80, height: 80)) |

## フレームワーク
UIKit.framework

## サポートOSバージョン
iOS2.0以上

## 開発環境
|category | Version|
|---|---|
| Swift | 3.0.2 |
| XCode | 8.2.1 |
| iOS | 10.0〜 |

## 参考
https://developer.apple.com/reference/uikit/uiimage
