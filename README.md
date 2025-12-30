# NavigationKit

> Typed SwiftUI navigation primitives with a single, app-defined destination model.

[![Swift Version](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fm1guelpf%2Fnavigationkit%2Fbadge%3Ftype%3Dswift-versions&color=brightgreen)](https://swiftpackageindex.com/m1guelpf/navigationkit)
[![Swift Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fm1guelpf%2Fnavigationkit%2Fbadge%3Ftype%3Dplatforms&color=brightgreen)](https://swiftpackageindex.com/m1guelpf/navigationkit)

## Installation

<details>

<summary>
Swift Package Manager
</summary>

Add the following to your `Package.swift`:

```swift
dependencies: [
	.package(url: "https://github.com/m1guelpf/navigationkit.git", .branch("main"))
]
```

</details>
<details>

<summary>Installing through XCode</summary>

-   File > Swift Packages > Add Package Dependency
-   Add https://github.com/m1guelpf/navigationkit.git
-   Select "Branch" with "main"

</details>

<details>

<summary>CocoaPods</summary>

Ask ChatGPT to help you migrate away from CocoaPods.

</details>

## Getting Started 🚀

Create a `Destination.swift` file somewhere in your project, re-export NavigationKit, and define your app's routes:

```swift
import SwiftUI
@_exported import NavigationKit

struct Destination: NavigationDestination {
    enum Tabs: String, TabRepresentable {
        case home
        case settings
    }

    enum Pages: PageRepresentable {
        case about
        case details(id: Int)

        var view: some View {
            switch self {
                case .about: AboutView()
                case let .details(id): DetailView(id: id)
            }
        }
    }

    enum Sheets: SheetRepresentable {
        case settings
        case browser(url: URL)

        var id: String {
            switch self {
                case .settings: "settings"
                case let .browser(url): "browser-\(url.absoluteString)"
            }
        }

        var content: some View {
            switch self {
                case .settings: SettingsSheet()
                case let .browser(url): BrowserSheet(url: url)
            }
        }
    }

    enum FullScreen: SheetRepresentable {
        case welcome
        case browser(url: URL)

        var id: String {
            switch self {
                case .welcome: "welcome"
                case let .browser(url): "browser-\(url.absoluteString)"
            }
         }

        @ViewBuilder var content: some View {
            switch self {
                case .welcome: WelcomeView()
                case let .browser(url): BrowserView(url: url)
            }
        }
    }

    enum Alerts: AlertRepresentable {
        case confirmDelete
        case error(message: String)

        var id: String {
            switch self {
                case .confirmDelete: "confirmDelete"
                case let .error(message): "error-\(message)"
            }
         }

        var alert: any NavigationKit.Alert {
            switch self {
                case .confirmDelete: ConfirmDeleteAlert()
                case let .error(message): ErrorAlert(message: message)
            }
        }
    }
}

// MARK: - Ergonomics

typealias Router = NavigationKit.Router<Destination>
typealias NavigationButton<Content: View> = NavigationKit.NavigationButton<Content, Destination>
typealias NavigationContainer<Content: View> = NavigationKit.NavigationContainer<Content, Destination>
```

Then, at the root of your app, create a `RootContainer` that holds the main `Router` and configures the `TabView` (if applicable) and `NavigationContainer`s:

```swift
import SwiftUI

struct RootContainer: View {
    @State var router = Router(level: 0, identifierTab: nil)

    var body: some View {
        TabView(selection: $router.selectedTab) {
            Tab("Home", systemImage: "house", value: Destination.Tabs.home) {
                NavigationContainer(parentRouter: router, tab: .home) {
                    HomeScreen()
                }
            }

            Tab("Settings", systemImage: "gear", value: Destination.Tabs.settings) {
                NavigationContainer(parentRouter: router, tab: .settings) {
                    SettingsScreen()
                }
            }
        }
        .environment(router)
    }
}
```

## Usage

Instead of `NavigationLink`, use `NavigationButton` to push, present sheets, full screen covers, or external links:

```swift
NavigationButton(push: .details(id: 42)) {
    Text("Open Details")
}

NavigationButton(sheet: .settings) {
    Text("Open Settings")
}

NavigationButton(destination: .external(url: URL(string: "https://example.com")!)) {
    Text("Open Website")
}
```

You can also drive navigation programmatically via the `Router`:

```swift
router.select(tab: .home)
router.navigate(push: .details(id: 42))
router.present(sheet: .settings)
router.present(fullScreen: .welcome)
router.present(alert: .error(message: "Something went wrong"))
router.pop()
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
