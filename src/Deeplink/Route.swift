import Foundation

/// A route definition that matches URL paths and produces deeplink values.
///
/// Routes consist of path segments (literals and parameters) and a factory
/// closure that creates the deeplink value from captured parameters.
public struct Route<Deeplink: DeeplinkRepresentable>: Sendable {
	/// The path segments that define this route's pattern.
	let segments: [PathSegment]

	/// A closure that creates a deeplink from captured parameter values.
	let factory: @Sendable ([String: Any]) -> Deeplink?

	/// Creates a route with the given segments and factory.
	public init(segments: [PathSegment], factory: @escaping @Sendable ([String: Any]) -> Deeplink?) {
		self.segments = segments
		self.factory = factory
	}

	/// Creates a route with no parameters.
	/// - Parameters:
	///   - segments: The path segments to match.
	///   - factory: A closure that returns the deeplink.
	public init(_ segments: PathSegment..., factory: @escaping @Sendable () -> Deeplink) {
		self.segments = segments
		self.factory = { _ in factory() }
	}

	/// Creates a route with one parameter.
	/// - Parameters:
	///   - s1: First path segment.
	///   - s2: Second path segment (parameter).
	///   - factory: A closure that takes the captured parameter and returns the deeplink.

	public init<P1: DeeplinkParameter>(
		_ s1: PathSegment,
		_ s2: PathSegment,
		factory: @escaping @Sendable (P1) -> Deeplink
	) {
		segments = [s1, s2]
		self.factory = { params in
			guard let p1 = params.values.first as? P1 else { return nil }
			return factory(p1)
		}
	}

	/// Creates a route with one parameter (single segment).
	/// - Parameters:
	///   - s1: Path segment (parameter).
	///   - factory: A closure that takes the captured parameter and returns the deeplink.
	public init<P1: DeeplinkParameter>(
		_ s1: PathSegment,
		factory: @escaping @Sendable (P1) -> Deeplink
	) {
		segments = [s1]
		self.factory = { params in
			guard let p1 = params.values.first as? P1 else { return nil }
			return factory(p1)
		}
	}

	/// Creates a route with two parameters.
	/// - Parameters:
	///   - s1: First path segment.
	///   - s2: Second path segment.
	///   - s3: Third path segment.
	///   - factory: A closure that takes the captured parameters and returns the deeplink.
	public init<P1: DeeplinkParameter, P2: DeeplinkParameter>(
		_ s1: PathSegment,
		_ s2: PathSegment,
		_ s3: PathSegment,
		factory: @escaping @Sendable (P1, P2) -> Deeplink
	) {
		segments = [s1, s2, s3]
		self.factory = { params in
			let values = Array(params.values)
			guard values.count >= 2,
			      let p1 = values[0] as? P1,
			      let p2 = values[1] as? P2
			else { return nil }
			return factory(p1, p2)
		}
	}

	/// Creates a route with three parameters.
	/// - Parameters:
	///   - s1: First path segment.
	///   - s2: Second path segment.
	///   - s3: Third path segment.
	///   - s4: Fourth path segment.
	///   - factory: A closure that takes the captured parameters and returns the deeplink.
	public init<P1: DeeplinkParameter, P2: DeeplinkParameter, P3: DeeplinkParameter>(
		_ s1: PathSegment,
		_ s2: PathSegment,
		_ s3: PathSegment,
		_ s4: PathSegment,
		factory: @escaping @Sendable (P1, P2, P3) -> Deeplink
	) {
		segments = [s1, s2, s3, s4]
		self.factory = { params in
			let values = Array(params.values)
			guard values.count >= 3,
			      let p1 = values[0] as? P1,
			      let p2 = values[1] as? P2,
			      let p3 = values[2] as? P3
			else { return nil }
			return factory(p1, p2, p3)
		}
	}

	/// Attempts to match a URL against this route's pattern.
	/// - Parameter url: The URL to match.
	/// - Returns: The deeplink value if the URL matches, or `nil` otherwise.
	func match(_ url: URL) -> Deeplink? {
		var components = url.pathComponents.filter { $0 != "/" }
		if let host = url.host() { components.insert(host, at: 0) }
		guard components.count == segments.count else { return nil }

		var capturedParams: [String: Any] = [:]

		for (segment, component) in zip(segments, components) {
			guard let result = segment.match(component) else { return nil }

			if case let .parameter(name, _) = segment {
				capturedParams[name] = result
			}
		}

		return factory(capturedParams)
	}
}

/// A collection of routes that can be used to match URLs.
public protocol RouteCollection: Sendable {
	associatedtype Deeplink: DeeplinkRepresentable

	/// The routes in this collection.
	var routes: [Route<Deeplink>] { get }
}

/// A concrete implementation of `RouteCollection`.
public struct _Routes<Deeplink: DeeplinkRepresentable>: RouteCollection, Sendable {
	public let routes: [Route<Deeplink>]

	public init(routes: [Route<Deeplink>]) {
		self.routes = routes
	}
}
