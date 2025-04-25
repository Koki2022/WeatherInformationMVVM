//
//  WeatherInfoViewModel.swift
//  WeatherInformationMVVM
//
//  Created by 高橋昴希 on 2025/04/21.
//

import Foundation
import Combine

// WeatherInfoViewModel.swift: 非同期処理（API通信）とUIの自動更新するため、SwiftUI + Combine を使った MVVM形式の天気情報取得ロジックを実装

class WeatherInfoViewModel: ObservableObject {
    // エラーメッセージをセット
    @Published var errorMessage: String?
    // 都市名
    @Published var cityName: String = "Tokyo"
    // 気温
    @Published var temperature: String = "--"
    // 天気の説明
    @Published var description: String = ""
    // 天気アイコン
    @Published var iconURL: URL?
    // AnyCancellableはCombineを明示にないと使えない
    // 複数の購読を管理するために Set<AnyCancellable> に格納。ViewModelが解放されるときに全ての購読をキャンセルすることができる
    private var cancellables = Set<AnyCancellable>()
    
    // 指定された都市名（cityName）から現在の天気情報を OpenWeatherMap API を使って取得し、画面に表示するためのデータを更新する処理する関数
    func fetchWeather() {
        // 都市名 cityName を使って天気APIのURLを組み立て
        guard let url = buildURL(for: cityName) else { return }
        // Combineの Publisher を使って、非同期でHTTPリクエストを開始
        // レスポンスの (data, response) タプルを発行するPublisherになる
        URLSession.shared.dataTaskPublisher(for: url)
        // data だけを取り出す
            .map(\.data)
        // JSONデータを WeatherResponse という構造体にデコード
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
        // デコードされたデータを受け取る処理（UI更新）を メインスレッド で実行
            .receive(on: DispatchQueue.main)
        // .sink() は Publisher を購読することで、データを受け取る処理を定義
        // receiveCompletion: 通信が終わったとき成功時と失敗時記載
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                    // 都市名に該当がないパターンと、ネットワーク接続が悪く天気情報が取得できないパターン
                    self.errorMessage = "天気情報の取得に失敗しました。\n都市名またはネットワーク接続を\n確認してください"
                case .finished:
                    break
                }
            },
                  // 正常にデータが返ってきたときにUI用のプロパティを更新
                  // [weak self] は、クロージャ内でself弱参照キャプチャする→self がまだ存在してたら処理を続け、いなかったら無視することでメモリ圧迫を防ぐ
                  receiveValue: { [weak self] response in
                // 成功時にAPIレスポンスを受け取る
                // 気温のセット
                self?.temperature = String(format: "%.1f℃", response.main.temp)
                // 天気の説明
                self?.description = response.weather.first?.description ?? ""
                // アイコン画像のURL作成
                if let icon = response.weather.first?.icon {
                    self?.iconURL = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                }
            }
            )
        // 購読（AnyCancellable）を ViewModel の cancellables に保持して、ViewModelが破棄されたときに自動で購読も解除
            .store(in: &cancellables)
    }
    
    // 指定された都市名から、OpenWeatherMap API用のURL を作成して返す関数
    private func buildURL(for city: String) -> URL? {
        // APIキーを取得
        let apiKey = APIKeyConfig.openWeatherMapAPIKey
        // 都市名に URLエンコード→URLにそのまま空白や日本語を含めると通信エラーになるため、安全な形式に変換
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        // OpenWeatherMap API のURL文字列を作る。
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(apiKey)&units=metric&lang=ja"
        return URL(string: urlString)
    }
}






