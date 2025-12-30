import SwiftUI
import Foundation

/// Defines various navigation destinations within the app.
@MainActor
public enum Destination<
	Tabs: TabRepresentable,
	Pages: PageRepresentable,
	Sheets: SheetRepresentable,
	FullScreen: FullScreenRepresentable,
	Alerts: AlertRepresentable
>: Hashable, Sendable {
	/// An external URL destination.
	case external(url: URL)

	/// A tab destination.
	case tab(_ destination: Tabs)

	/// A page destination.
	case push(_ destination: Pages)

	/// An alert destination.
	case alert(_ destination: Alerts)

	/// A sheet destination.
	case sheet(_ destination: Sheets)

	/// A full-screen destination.
	case fullScreen(_ destination: FullScreen)

	/// Retrieves the contained page destination, if available.
	public var asPage: Pages? {
		guard case let .push(page) = self else { return nil }
		return page
	}
}
