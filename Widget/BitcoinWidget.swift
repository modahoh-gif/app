import WidgetKit
import SwiftUI
import ActivityKit

struct BitcoinWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BitcoinAttributes.self) { context in
            // شاشة القفل
            Text("BTC: \(context.state.price)")
                .font(.largeTitle).bold()
        } dynamicIsland: { context in
            DynamicIsland {
                // التصميم عند الضغط المطول على الجزيرة
                DynamicIslandExpandedRegion(.center) {
                    Text("Bitcoin Live")
                    Text(context.state.price).font(.largeTitle).foregroundColor(.green)
                }
            } compactLeading: {
                // التصميم المصغر (يسار)
                Image(systemName: "bitcoinsign.circle.fill").foregroundColor(.orange)
            } compactTrailing: {
                // التصميم المصغر (يمين) - السعر
                Text(context.state.price).bold().foregroundColor(.green)
            } minimal: {
                Text("₿").foregroundColor(.orange)
            }
        }
    }
}
