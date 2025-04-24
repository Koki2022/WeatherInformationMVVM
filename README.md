# WeatherInformationMVVM
都市名を入力して最新の天気を表示するアプリ(MVVM)

## 1.概要
アプリを起動すると、都市名を入力する欄が表示されます。お好きな都市名を英語で入力してください（初期値として「Tokyo」が入力されています）。
入力が完了すると、その都市の最新の天気情報が取得され、天気アイコン、気温、天候の説明が表示されます。

## 2.実行画面

【初期画面(東京)】

<img src="https://github.com/user-attachments/assets/a392bc1c-e20d-4933-bdc4-cf223371c2df" width="20%">

【札幌と入力後】

<img src="https://github.com/user-attachments/assets/f2ec0e3a-c6e9-4fb7-a435-23fc4ed6f1f6" width="20%">

## 3.アプリの機能
・入力した都市名の最新の天気情報を表示

## 4.アプリの設計について

【画面遷移とボタン押下時の処理フロー】

<img width="391" alt="スクリーンショット 2025-04-21 7 04 08" src="https://github.com/user-attachments/assets/14d5e679-97e7-4d53-93ca-30addf97f50d" />

【システム処理の流れを表すシーケンス図】

<img width="773" alt="スクリーンショット 2025-04-21 7 22 04" src="https://github.com/user-attachments/assets/a548b53d-5d0c-48ad-aef4-fa791ffd9c5b" />

【各ファイルと役割】

|種類|ファイル名|概要|
|:---:|:---:|:---:|
|View|WeatherInfoView|入力された都市名の最新の天気を表示するView|
|ViewModel|WeatherInfoViewModel|SwiftUI + Combine を使った非同期処理（API通信）とUIの自動更新を行う天気情報取得ロジックを実装|
|Model|OriginalSearchBarView|OpenWeatherMapのJSON構造に対応するデータの構造体を定義するファイル|

## 5. 工夫したコード／設計
### OpenWeatherMap APIを活用し、天気情報を取得するコードを実装しました。
・OpenWeatherMap APIの外部ライブラリをアプリに取り入れ、天気アイコン、気温、気候の説明といった天気情報を取得するコードを実装しました。

## 6. 開発環境
Xcode 16.2
iOS 17.0以降が必要です

