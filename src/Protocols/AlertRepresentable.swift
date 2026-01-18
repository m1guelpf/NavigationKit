import SwiftUI

/// Your app's alert representation.
public protocol AlertRepresentable: Identifiable, Equatable, Hashable, Sendable {
	/// The content of the alert.
	@MainActor var alert: any Alert { get }
}

/// A placeholder type for apps that don't use alerts.
///
/// This type is used as the default `Alerts` associated type in
/// `NavigationDestination`. It has no alerts and will never trigger.
///
/// You don't need to interact with this type directly. Simply omit the
/// `Alerts` typealias from your `NavigationDestination` conformance
/// to use this default.
public enum NoAlerts: Identifiable, AlertRepresentable {
	public var id: String {
		switch self {
			//
		}
	}

	public var alert: any Alert {
		switch self {
			//
		}
	}
}
