import Foundation

/// A protocol for types that represent deeplink destinations.
///
/// Implement this protocol to define the deeplinks your app supports.
/// Each deeplink case maps to a navigation destination through the
/// `destination` property.
///
/// ```swift
/// enum Deeplinks: DeeplinkRepresentable {
///     case settings
///     case page(id: Int)
///
///     var destination: AppDestination.Kind {
///         switch self {
///         	case .settings: .push(.settings)
///        		case .page(let id): .push(.details(id: id))
///         }
///     }
///
///     static var routes: some RouteCollection {
///         Route("settings") { .settings }
///
///         Route("page", Int.parameter("id")) { id in
///             .page(id: id)
///         }
///     }
/// }
/// ```
public protocol DeeplinkRepresentable: Hashable, Sendable {
	/// The navigation destination type this deeplink maps to.
	associatedtype Using: NavigationDestination

	/// The route collection type returned by `routes`.
	associatedtype Routes: RouteCollection where Routes.Deeplink == Self

	/// The URL scheme for deeplinks of this app.
	static var scheme: String { get }

	/// The navigation destination this deeplink should navigate to.
	var destination: Using.Kind { get }

	/// The routes that define how URLs map to deeplink values.
	@RouteBuilder<Self> static var routes: Self.Routes { get }
}

public extension DeeplinkRepresentable {
	typealias Routes = _Routes<Self>
}

/// A placeholder type for apps that don't use deeplinks.
///
/// This type is used as the default `Deeplinks` associated type in
/// `NavigationDestination`. It has no routes and will never match any URLs.
///
/// You don't need to interact with this type directly. Simply omit the
/// `Deeplinks` typealias from your `NavigationDestination` conformance
/// to use this default.
public enum NoDeeplinks<D: NavigationDestination>: DeeplinkRepresentable, Hashable, Sendable {
	public typealias Using = D

	public static var scheme: String {
		"app"
	}

	public var destination: D.Kind {
		fatalError("NoDeeplinks has no cases and cannot be instantiated")
	}

	public static var routes: _Routes<NoDeeplinks<D>> {}
}
