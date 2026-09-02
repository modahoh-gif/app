import Foundation
import ActivityKit
import AVFoundation

public class BitcoinManager: ObservableObject {
    private var webSocket: URLSessionWebSocketTask?
    private var engine = AVAudioEngine()
    private var player = AVAudioPlayerNode()
    private var activity: Activity<BitcoinAttributes>?

    public init() {}

    public func start() {
        startSilentAudio()
        startActivity()
        connectWebSocket()
    }

    private func startSilentAudio() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        engine.attach(player)
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
        engine.connect(player, to: engine.mainMixerNode, format: format)
        try? engine.start()
        player.play()
    }

    private func startActivity() {
        let attributes = BitcoinAttributes(pair: "BTC/USDT")
        let initialState = BitcoinAttributes.ContentState(price: "Connecting...")
        let content = ActivityContent(state: initialState, staleDate: nil)
        
        do {
            activity = try Activity.request(attributes: attributes, content: content)
        } catch {
            print("Error starting Live Activity: \(error)")
        }
    }

    private func connectWebSocket() {
        let url = URL(string: "wss://stream.binance.com:9443/ws/btcusdt@ticker")!
        webSocket = URLSession.shared.webSocketTask(with: url)
        webSocket?.resume()
        receiveMessage()
    }

    private func receiveMessage() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                if case .string(let text) = message,
                   let data = text.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let priceStr = json["c"] as? String {
                    
                    let doublePrice = Double(priceStr) ?? 0
                    let formattedPrice = String(format: "$%.1f", doublePrice)
                    self?.updateIsland(price: formattedPrice)
                }
                self?.receiveMessage()
            case .failure:
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.connectWebSocket()
                }
            }
        }
    }

    private func updateIsland(price: String) {
        Task {
            let state = BitcoinAttributes.ContentState(price: price)
            let content = ActivityContent(state: state, staleDate: nil)
            await activity?.update(content)
        }
    }
}
