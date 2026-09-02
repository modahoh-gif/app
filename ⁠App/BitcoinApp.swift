import SwiftUI

@main
struct BitcoinApp: App {
    @StateObject private var manager = BitcoinManager()

    var body: some Scene {
        WindowGroup {
            VStack(spacing: 20) {
                Image(systemName: "bitcoinsign.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.orange)
                Text("Bitcoin Live Island")
                    .font(.title).bold()
                Text("الخدمة تعمل في الخلفية الآن.. تفقد الجزيرة التفاعلية (Dynamic Island)")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
                Button("تشغيل الاتصال") {
                    manager.start()
                }
                .buttonStyle(.borderedProminent)
            }
            .onAppear {
                manager.start()
            }
        }
    }
}
