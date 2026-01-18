import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// A generic router to manage navigation state for a given `NavigationDestination`.
///
/// /// For convenience, it's recommended to typealias `Router` with your app's specific `NavigationDestination` type.
@MainActor @Observable
public final class Router<D: NavigationDestination> {
	/// A unique identifier for the router instance.
	public let id = UUID()

	/// The hierarchical level of the router.
	public let level: Int

	/// The currently selected tab (only relevant for top-level routers).
	public var selectedTab: D.Tabs?

	/// The identifier of the tab associated with this router.
	public let identifierTab: D.Tabs?

	/// The currently presented alert.
	public var presentingAlert: D.Alerts?

	/// The currently presented sheet.
	public var presentingSheet: D.Sheets?

	/// The currently presented full-screen cover.
	public var presentingFullScreen: D.FullScreen?

	/// The navigation stack path for push navigation.
	public var navigationStackPath: [D.Pages] = []

	/// The parent router in the hierarchy.
	public private(set) weak var parent: Router?

	/// Indicates whether the router is currently active.
	public private(set) var isActive: Bool = false

	/// Initializes a new router instance.
	///
	/// - Parameter level The hierarchical level of the router.
	/// - Parameter identifierTab The identifier of the tab associated with this router.
	public init(level: Int, identifierTab: D.Tabs?) {
		parent = nil
		self.level = level
		self.identifierTab = identifierTab
	}

	public init(level: Int) where D.Tabs == NoTabs {
		parent = nil
		self.level = level
		identifierTab = nil
	}

	private func resetContent() {
		presentingAlert = nil
		presentingSheet = nil
		navigationStackPath = []
		presentingFullScreen = nil
	}

	private func openExternalURL(_ url: URL) {
		#if canImport(UIKit)
		UIApplication.shared.open(url)
		#elseif canImport(AppKit)
		NSWorkspace.shared.open(url)
		#endif
	}
}

// MARK: - Router Management

public extension Router {
	/// Creates a child router for the specified tab.
	func childRouter(for tab: D.Tabs? = nil) -> Router {
		let router = Router(level: level + 1, identifierTab: tab ?? identifierTab)
		router.parent = self
		return router
	}

	/// Marks this router as active and resigns activity from the parent router.
	func setActive() {
		parent?.resignActive()
		isActive = true
	}

	/// Marks this router as inactive.
	func resignActive() {
		isActive = false
	}

	/// Creates a preview router instance for SwiftUI previews.
	static func previewRouter() -> Router {
		Router(level: 0, identifierTab: nil)
	}

	/// Provides a binding to determine if an alert is being presented.
	subscript(alert _: KeyPath<Router, D.Alerts?>) -> Binding<Bool> {
		Binding(
			get: { self.presentingAlert != nil },
			set: { newValue in
				if !newValue { self.presentingAlert = nil }
			}
		)
	}
}

// MARK: - Navigation

public extension Router {
	/// Navigates to the specified destination.
	/// - Parameter destination The destination to navigate to.
	func navigate(to destination: D.Kind) {
		switch destination {
			case let .tab(tab): select(tab: tab)
			case let .external(url): openExternalURL(url)
			case let .push(destination): push(destination)
			case let .alert(destination): presentingAlert = destination
			case let .sheet(destination): presentingSheet = destination
			case let .fullScreen(destination): presentingFullScreen = destination
		}
	}

	/// Navigates to the specified tab.
	/// - Parameter tab The tab to select.
	func select(tab destination: D.Tabs) {
		if level == 0 { selectedTab = destination }
		else {
			parent?.select(tab: destination)
			resetContent()
		}
	}

	/// Pushes a new page onto the navigation stack.
	/// - Parameter page The page to push.
	func push(_ page: D.Pages) {
		navigationStackPath.append(page)
	}

	/// Presents a sheet.
	/// - Parameter sheet The sheet to present.
	func present(sheet destination: D.Sheets) {
		presentingSheet = destination
	}

	/// Presents a full-screen cover.
	/// - Parameter fullScreen The full-screen cover to present.
	func present(fullScreen destination: D.FullScreen) {
		presentingFullScreen = destination
	}

	/// Presents an alert.
	/// - Parameter alert The alert to present.
	func present(alert destination: D.Alerts) {
		presentingAlert = destination
	}

	/// Navigates back by popping the last page from the navigation stack.
	func pop() {
		_ = navigationStackPath.popLast()
	}
}

// MARK: - Deeplink Handling

public extension Router {
	/// Handles a parsed deeplink by navigating to its destination.
	/// - Parameters:
	///   - deeplink: The deeplink to handle.
	///   - dismissFirst: Whether to dismiss all presented content before navigating.
	func handle(deeplink: D.Deeplinks, dismissFirst: Bool = true) {
		if dismissFirst { resetContent() }

		// We need to cast the destination to the correct type
		// This is safe because DeeplinkRepresentable.Destination is constrained to NavigationDestination
		if let destination = deeplink.destination as? D.Kind {
			navigate(to: destination)
		}
	}

	/// Attempts to parse and handle a URL as a deeplink.
	/// - Parameters:
	///   - url: The URL to parse and handle.
	///   - configuration: The parser configuration.
	/// - Returns: `true` if the URL was successfully handled, `false` otherwise.
	@discardableResult
	func handleURL(_ url: URL, configuration: DeeplinkParser<D>.Configuration = .default) -> Bool {
		let parser = DeeplinkParser<D>(configuration: configuration)

		guard let deeplink = parser.parse(url) else { return false }

		handle(deeplink: deeplink, dismissFirst: configuration.dismissBeforeNavigating)
		return true
	}
}

// MARK: - Debugging

extension Router: @MainActor CustomDebugStringConvertible {
	public var debugDescription: String {
		"Router[\(shortId) - \(identifierTabName) - Level: \(level)]"
	}

	private var shortId: String { String(id.uuidString.split(separator: "-").first ?? "") }

	private var identifierTabName: String {
		identifierTab?.rawValue ?? "No Tab"
	}
}
