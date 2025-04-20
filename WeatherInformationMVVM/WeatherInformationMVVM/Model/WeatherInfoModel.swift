//
//  WeatherInfoModel.swift
//  WeatherForecastTest
//
//  Created by 高橋昴希 on 2025/04/21.
//

import Foundation

// WeatherInfoModel.swift: OpenWeatherMapのJSON構造に対応するデータの構造体を定義するファイル

// API全体のレスポンスを表す構造体を実装
struct WeatherResponse: Decodable { //Decodable: APIから返ってきたJSONを構造体に変換できる
    let name: String // 都市名
    let main: Main // 気温などの情報を格納
    let weather: [Weather] // 天気の詳細
}

// "main" の中にあるデータに対応
struct Main: Decodable {
    let temperature: Double // 気温
}

// 天気の説明やアイコンを表す配列要素
struct Weather: Decodable {
    let description: String // 天気の説明
    let icon: String //　天気のアイコン
}
