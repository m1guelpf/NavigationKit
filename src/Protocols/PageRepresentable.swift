import SwiftUI

/// Your app's page representation.
public protocol PageRepresentable: Equatable, Hashable, Sendable {
	associatedtype Content: View

	/// The content of the page.
	@MainActor @ViewBuilder var view: Content { get }
}
