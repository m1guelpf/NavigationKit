import SwiftUI

/// Your app's full screen cover representation.
public protocol FullScreenRepresentable: Identifiable, Equatable, Hashable, Sendable {
	associatedtype FullScreen: View

	/// The content of the full screen cover.
	@MainActor @ViewBuilder var content: FullScreen { get }
}
