import SwiftUI

/// A container view that provides navigation capabilities using a `Router`
///
/// /// For convenience, it's recommended to typealias `NavigationContainer` with your app's specific `NavigationDestination` type.
public struct NavigationContainer<Content: View, D: NavigationDestination>: View {
	/// The router managing navigation within this container
	@State var router: Router<D>

	/// The content view displayed within the navigation container
	@ViewBuilder var content: () -> Content

	/// Initializes a new `NavigationContainer` with a parent router and optional tab
	/// - Parameter parentRouter: The parent router to derive the child router from
	/// - Parameter tab: An optional tab identifier for the child router
	/// - Parameter content: A closure that produces the content view
	public init(parentRouter: Router<D>, tab: D.Tabs? = nil, @ViewBuilder content: @escaping () -> Content) {
		self.content = content
		_router = .init(initialValue: parentRouter.childRouter(for: tab))
	}

	public var body: some View {
		InnerContainer(router: router) {
			content()
		}
		.environment(router)
		.onAppear(perform: router.setActive)
		.onDisappear(perform: router.resignActive)
	}
}

// This is necessary for getting a binder from an Environment Observable object
private struct InnerContainer<Content: View, D: NavigationDestination>: View {
	@Bindable var router: Router<D>
	@ViewBuilder var content: () -> Content

	var body: some View {
		NavigationStack(path: $router.navigationStackPath) {
			content()
				.navigationDestination(for: D.Pages.self) { destination in
					destination.view
				}
		}
		// it's important that the these modifiers are **outside** the `NavigationStack`
		// otherwise the content closure will be called infinitely freezing the app
		.sheet(item: $router.presentingSheet) { sheet in
			NavigationContainer(parentRouter: router) {
				sheet.view
			}
		}
		#if os(iOS)
		.fullScreenCover(item: $router.presentingFullScreen) { fullScreen in
			NavigationContainer(parentRouter: router) {
				fullScreen.content
			}
		}
		#endif
		.alert(
			router.presentingAlert?.alert.title ?? "",
			isPresented: router[alert: \.presentingAlert],
			presenting: router.presentingAlert,
			actions: { AnyView($0.alert.actions) },
			message: { $0.alert.message.map { Text($0) } }
		)
		.onOpenURL { url in
			guard router.level == 1 else { return }

			router.handleURL(url)
		}
	}

	@ViewBuilder func navigationView(for destination: D.Sheets, from router: Router<D>) -> some View {
		NavigationContainer(parentRouter: router) {
			destination.view
		}
	}
}
