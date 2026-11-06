import SwiftUI
import UIKit

@main
struct ActivationPointReproApp: App {
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 20) {
                Menu("SwiftUI Menu") { Button("Item") {} }
                UIKitButton(title: "UIKit Button With Title")
                UIKitButton(title: nil)
                    .accessibilityLabel("UIKit Button Without Title")
            }
            .task {
                try? await Task.sleep(for: .seconds(0.25))
                printActivationPoints()
            }
        }
    }
}

struct UIKitButton: UIViewRepresentable {
    let title: String?

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        return button
    }

    func updateUIView(_ button: UIButton, context: Context) {}

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIButton, context: Context) -> CGSize? {
        CGSize(width: 240, height: 44)
    }
}

/// Prints every accessibility element's activation point, found with public API only.
func printActivationPoints() {
    func visit(_ object: NSObject) {
        if object.isAccessibilityElement {
            print("\"\(object.accessibilityLabel ?? "")\" activationPoint=\(object.accessibilityActivationPoint) accessibilityFrame=\(object.accessibilityFrame)")
        } else if let elements = object.accessibilityElements as? [NSObject], !elements.isEmpty {
            elements.forEach(visit)
        } else if let view = object as? UIView {
            view.subviews.forEach(visit)
        }
    }
    UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .forEach(visit)
}
