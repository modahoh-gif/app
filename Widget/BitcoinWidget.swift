import WidgetKit
import SwiftUI
import ActivityKit

@main
struct BitcoinWidgetBundle: WidgetBundle {
    var body: some Widget {
        BitcoinWidget()
    }
}

struct BitcoinWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BitcoinAttributes.self) { context in
            VStack {
                Text("BTC Live: \(context.state.price)")
                    .font(.headline)
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    Text("Bitcoin Price")
                        .font(.caption).foregroundColor(.secondary)
                    Text(context.state.price)
                        .font(.title).bold().foregroundColor(.green)
                }
            } compactLeading: {
                Image(systemName: "b.circle.fill").foregroundColor(.orange)
            } compactTrailing: {
                Text(context.state.price)
                    .font(.caption2).bold().foregroundColor(.green)
            } minimal: {
                Text("₿").foregroundColor(.orange)
            }
        }
    }
}
