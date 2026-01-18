import SwiftUI

/// Your app's page representation.
public protocol PageRepresentable: Equatable, Hashable, Sendable {
	associatedtype Content: View

	/// The content of the page.
	@MainActor @ViewBuilder var view: Content { get }
}

/// A placeholder type for apps that don't use pages.
///
/// This type is used as the default `Pages` associated type in
/// `NavigationDestination`. It has no pages and will never trigger.
///
/// You don't need to interact with this type directly. Simply omit the
/// `Pages` typealias from your `NavigationDestination` conformance
/// to use this default.
public enum NoPages: PageRepresentable {
	public var view: some View {
		switch self {
			default: EmptyView()
		}
	}
}
