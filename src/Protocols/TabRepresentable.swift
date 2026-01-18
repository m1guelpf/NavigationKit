import SwiftUI

/// Your app's tab representation.
@MainActor
public protocol TabRepresentable: RawRepresentable<String>, CaseIterable, Hashable, Sendable {}

/// A placeholder type for apps that don't use tabs.
///
/// This type is used as the default `Tabs` associated type in
/// `NavigationDestination`. It has no tabs and will never trigger.
///
/// You don't need to interact with this type directly. Simply omit the
/// `Tabs` typealias from your `NavigationDestination` conformance
/// to use this default.
@MainActor public enum NoTabs: RawRepresentable, TabRepresentable {
	public nonisolated init?(rawValue _: String) {
		return nil
	}

	public nonisolated var rawValue: String {
		switch self {}
	}
}
