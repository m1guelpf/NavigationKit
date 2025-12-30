import SwiftUI

/// Your app's tab representation.
@MainActor
public protocol TabRepresentable: RawRepresentable<String>, CaseIterable, Hashable, Sendable {}
