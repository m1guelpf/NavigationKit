import SwiftUI

/// Your app's sheet representation.
public protocol SheetRepresentable: Identifiable, Equatable, Hashable, Sendable {
	associatedtype Sheet: View

	/// The presentation detents for the sheet.
	var detents: Set<PresentationDetent> { get }

	/// The toolbar title display mode for the sheet.
	var titleDisplayMode: ToolbarTitleDisplayMode { get }

	/// The content of the sheet.
	@MainActor @ViewBuilder var content: Sheet { get }
}

public extension SheetRepresentable {
	var detents: Set<PresentationDetent> {
		[.medium, .large]
	}

	var titleDisplayMode: ToolbarTitleDisplayMode {
		.inline
	}

	/// Renders the sheet view with the specified detents and title display mode.
	@MainActor var view: some View {
		content
			.presentationDetents(detents)
			.toolbarTitleDisplayMode(titleDisplayMode)
	}
}

/// A placeholder type for apps that don't use sheets.
///
/// This type is used as the default `Sheets` associated type in
/// `NavigationDestination`. It has no sheets and will never trigger.
///
/// You don't need to interact with this type directly. Simply omit the
/// `Sheets` typealias from your `NavigationDestination` conformance
/// to use this default.
public enum NoSheets: Identifiable, SheetRepresentable {
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
