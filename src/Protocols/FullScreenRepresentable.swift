import SwiftUI

/// Your app's full screen cover representation.
public protocol FullScreenRepresentable: Identifiable, Equatable, Hashable, Sendable {
	associatedtype FullScreen: View

	/// The content of the full screen cover.
	@MainActor @ViewBuilder var content: FullScreen { get }
}

/// A placeholder type for apps that don't use full screen presentations.
///
/// This type is used as the default `FullScreen` associated type in
/// `NavigationDestination`. It has no presentations and will never trigger.
///
/// You don't need to interact with this type directly. Simply omit the
/// `FullScreen` typealias from your `NavigationDestination` conformance
/// to use this default.
public enum NoFullScreen: Identifiable, FullScreenRepresentable {
	public var id: String {
		switch self {
			//
		}
	}

	public var content: some View {
		switch self {
			default: EmptyView()
		}
	}
}
