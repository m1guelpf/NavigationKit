import SwiftUI

/// An abstraction for alerts in SwiftUI.
///
/// This protocol defines the structure of an alert, including its title, optional message, and actions.
@MainActor public protocol Alert {
	associatedtype Actions: View

	/// The title of the alert.
	var title: String { get }

	/// The optional message of the alert.
	var message: String? { get }

	/// The actions to be displayed in the alert.
	@ViewBuilder var actions: Actions { get }
}

extension Alert {
	var message: String? { nil }
}
