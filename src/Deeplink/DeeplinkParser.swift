import Foundation

/// A parser that matches URLs against defined routes and produces deeplink values.
///
/// The parser uses the routes defined on the `DeeplinkRepresentable` type to match incoming URLs and extract parameters.
@MainActor public struct DeeplinkParser<D: NavigationDestination> where D.Deeplinks: DeeplinkRepresentable {
	/// Configuration options for deeplink parsing.
	public struct Configuration: Sendable {
		/// Whether to dismiss presented content before navigating.
		public var dismissBeforeNavigating: Bool

		/// Creates a new configuration with the specified options.
		/// - Parameter dismissBeforeNavigating: Whether to dismiss presented content first.
		public init(dismissBeforeNavigating: Bool = false) {
			self.dismissBeforeNavigating = dismissBeforeNavigating
		}

		/// The default configuration.
		public static var `default`: Configuration { Configuration() }
	}

	/// The configuration for this parser.
	public let configuration: Configuration

	/// Creates a new parser with the given configuration.
	/// - Parameter configuration: The parser configuration.
	public init(configuration: Configuration = .default) {
		self.configuration = configuration
	}

	/// Attempts to parse a URL into a deeplink value.
	/// - Parameter url: The URL to parse.
	/// - Returns: The matched deeplink, or `nil` if no route matched.
	public func parse(_ url: URL) -> D.Deeplinks? {
		guard let scheme = url.scheme?.lowercased(), scheme == D.Deeplinks.scheme.lowercased() else { return nil }

		let routes = D.Deeplinks.routes.routes

		for route in routes {
			if let deeplink = route.match(url) {
				return deeplink
			}
		}

		return nil
	}
}
