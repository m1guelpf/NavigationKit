/// Implement this protocol to define the navigation destinations for your app.
public protocol NavigationDestination: Hashable {
	associatedtype Tabs: TabRepresentable = NoTabs
	associatedtype Pages: PageRepresentable = NoPages
	associatedtype Sheets: SheetRepresentable = NoSheets
	associatedtype FullScreen: FullScreenRepresentable = NoFullScreen
	associatedtype Alerts: AlertRepresentable = NoAlerts
	associatedtype Deeplinks: DeeplinkRepresentable = NoDeeplinks<Self>

	typealias Kind = Destination<Tabs, Pages, Sheets, FullScreen, Alerts>
}
