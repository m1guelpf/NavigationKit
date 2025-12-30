/// Implement this protocol to define the navigation destinations for your app.
public protocol NavigationDestination: Hashable {
	associatedtype Tabs: TabRepresentable
	associatedtype Pages: PageRepresentable
	associatedtype Sheets: SheetRepresentable
	associatedtype FullScreen: FullScreenRepresentable
	associatedtype Alerts: AlertRepresentable

	typealias Kind = Destination<Tabs, Pages, Sheets, FullScreen, Alerts>
}
