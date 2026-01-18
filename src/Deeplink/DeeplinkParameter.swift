import Foundation

/// A protocol for types that can be extracted from URL path segments.
///
/// Conforming types can be used as parameters in deeplink routes.
public protocol DeeplinkParameter: Sendable {
	/// Creates a path segment that captures a parameter of this type.
	/// - Parameter name: The name of the parameter (used for debugging and documentation).
	/// - Returns: A `PathSegment` representing a parameter capture.
	static func parameter(_ name: String) -> PathSegment

	/// Creates an instance of this type from a string representation.
	/// - Parameter string: The string representation of the parameter.
	/// - Returns: An instance of this type, or `nil` if the string could not be converted.
	static func fromParameterString(_ string: String) -> Self?
}

public extension DeeplinkParameter {
	static func parameter(_ name: String) -> PathSegment {
		.parameter(name: name, type: Self.self)
	}
}

extension Int: DeeplinkParameter {
	public static func fromParameterString(_ string: String) -> Int? {
		Int(string)
	}
}

extension Bool: DeeplinkParameter {
	public static func fromParameterString(_ string: String) -> Bool? {
		switch string.lowercased() {
			case "true", "1": return true
			case "false", "0": return false
			default: return nil
		}
	}
}

extension String: DeeplinkParameter {
	public static func fromParameterString(_ string: String) -> String? {
		string
	}
}

extension UUID: DeeplinkParameter {
	public static func fromParameterString(_ string: String) -> UUID? {
		UUID(uuidString: string)
	}
}
