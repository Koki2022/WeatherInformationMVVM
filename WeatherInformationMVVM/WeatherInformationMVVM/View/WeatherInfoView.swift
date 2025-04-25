//
//  WeatherInfoView.swift
//  WeatherInformationMVVM
//
//  Created by 高橋昴希 on 2025/04/21.
//

// WeatherInfoView.swift: 最新の天気を表示するView
import SwiftUI

struct WeatherInfoView: View {
    @StateObject private var viewModel = WeatherInfoViewModel()
    var body: some View {
        VStack(spacing: 20) {
            // 入力完了時、天気情報を取得する関数を実行
            TextField("都市名を入力", text: $viewModel.cityName, onCommit: {
                viewModel.fetchWeather()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            // 天気アイコン表示
            if let iconURL = viewModel.iconURL {
                AsyncImage(url: iconURL) { image in
                    image.resizable()
                    // placeholderを実装するとSwiftが使うべきイニシャライザを明確にできる
                    // 画像を読み込み中の時の処理
                } placeholder: {
                    // 進行画面
                    ProgressView()
                }
                .frame(width: 100, height: 100)
            }
            // 気温情報
            Text(viewModel.temperature)
                .font(.largeTitle)
                .bold()
            Text(viewModel.description)
                .font(.title3)
                .bold()
        }
        // 画面表示時にも天気情報を取得する関数を実行
        .onAppear {
            viewModel.fetchWeather()
        }
        // アラート設定
        .alert("エラー", isPresented: Binding<Bool>(
            // エラーメッセージがnilでないのを判断してアラートを出す
            get: { viewModel.errorMessage != nil },
            // アラートを閉じた時にerrorMessageをnilにして次のエラーが表示されるようにする
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    WeatherInfoView()
}
