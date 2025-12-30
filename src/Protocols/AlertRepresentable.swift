import SwiftUI

/// Your app's alert representation.
public protocol AlertRepresentable: Identifiable, Equatable, Hashable, Sendable {
	/// The content of the alert.
	@MainActor var alert: any Alert { get }
}
