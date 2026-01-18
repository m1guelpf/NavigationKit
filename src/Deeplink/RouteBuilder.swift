import Foundation

/// A result builder for constructing route collections declaratively.
///
/// Use this builder with the `@RouteBuilder` attribute to define routes cleanly.
///
/// ```swift
/// static var routes: some RouteCollection {
///     Route("page", Int.parameter("id")) { id in
///         .page(id: id)
///     }
///     Route("settings") { .settings }
/// }
/// ```
@resultBuilder
public struct RouteBuilder<Deeplink: DeeplinkRepresentable> {
	/// Builds a route collection from a variadic list of routes.
	public static func buildBlock(_ routes: Route<Deeplink>...) -> _Routes<Deeplink> {
		_Routes(routes: routes)
	}

	/// Builds a route collection from an array of routes.
	public static func buildBlock(_ routes: [Route<Deeplink>]) -> _Routes<Deeplink> {
		_Routes(routes: routes)
	}

	/// Builds an optional route (for `if` statements without `else`).
	public static func buildOptional(_ route: Route<Deeplink>?) -> [Route<Deeplink>] {
		route.map { [$0] } ?? []
	}

	/// Builds the first branch of a conditional (`if` branch).
	public static func buildEither(first routes: _Routes<Deeplink>) -> _Routes<Deeplink> {
		routes
	}

	/// Builds the second branch of a conditional (`else` branch).
	public static func buildEither(second routes: _Routes<Deeplink>) -> _Routes<Deeplink> {
		routes
	}

	/// Builds an array of routes (for `for` loops).
	public static func buildArray(_ components: [_Routes<Deeplink>]) -> _Routes<Deeplink> {
		_Routes(routes: components.flatMap(\.routes))
	}

	/// Converts a single route to an array (for combining with optionals).
	public static func buildExpression(_ route: Route<Deeplink>) -> Route<Deeplink> {
		route
	}

	/// Passes through a routes collection.
	public static func buildFinalResult(_ component: _Routes<Deeplink>) -> _Routes<Deeplink> {
		component
	}
}
