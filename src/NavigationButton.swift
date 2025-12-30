import SwiftUI

/// A button that navigates to a specified destination when tapped.
///
/// For convenience, it's recommended to typealias `NavigationButton` with your app's specific `NavigationDestination` type.
public struct NavigationButton<Content: View, D: NavigationDestination>: View {
	/// The destination to navigate to when the button is tapped.
	let destination: D.Kind?

	@ViewBuilder var content: () -> Content
	@Environment(Router<D>.self) private var router

	/// Creates a new `NavigationButton`.
	/// - Parameter destination: The destination to navigate to when the button is tapped.
	/// - Parameter content: A closure that produces the button's content.
	public init(destination: D.Kind? = nil, @ViewBuilder content: @escaping () -> Content) {
		self.content = content
		self.destination = destination
	}

	/// Creates a new `NavigationButton`.
	/// - Parameter push: The page destination to navigate to when the button is tapped.
	/// - Parameter content: A closure that produces the button's content.
	public init(push destination: D.Pages? = nil, @ViewBuilder content: @escaping () -> Content) {
		self.content = content
		self.destination = destination.map { .push($0) }
	}

	/// Creates a new `NavigationButton`.
	/// - Parameters alert: The alert to present when the button is tapped.
	/// - Parameter content: A closure that produces the button's content.
	public init(alert destination: D.Alerts? = nil, @ViewBuilder content: @escaping () -> Content) {
		self.content = content
		self.destination = destination.map { .alert($0) }
	}

	/// Creates a new `NavigationButton`.
	/// - Parameter sheet: The sheet destination to present when the button is tapped.
	/// - Parameter content: A closure that produces the button's content.
	public init(sheet destination: D.Sheets? = nil, @ViewBuilder content: @escaping () -> Content) {
		self.content = content
		self.destination = destination.map { .sheet($0) }
	}

	/// Creates a new `NavigationButton`.
	/// - Parameter fullScreen: The full-screen destination to present when the button is tapped.
	/// - Parameter content: A closure that produces the button's content.
	public init(fullScreen destination: D.FullScreen? = nil, @ViewBuilder content: @escaping () -> Content) {
		self.content = content
		self.destination = destination.map { .fullScreen($0) }
	}

	public var body: some View {
		Button(action: navigate) {
			content()
		}
		.disabled(destination == nil)
	}

	private func navigate() {
		guard let destination else { return }

		router.navigate(to: destination)
	}
}
