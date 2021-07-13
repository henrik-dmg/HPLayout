#if os(iOS) || os(tvOS)
import UIKit
#endif

#if os(OSX)
import AppKit
#endif

#if os(iOS) || os(OSX) || os(tvOS)
/// Based on Antoine Van Der Lee's implementation
/// https://www.avanderlee.com/swift/result-builders/
@resultBuilder public struct AutolayoutBuilder {

	public static func buildBlock(_ components: LayoutGroup...) -> [NSLayoutConstraint] {
		components.flatMap { $0.constraints }
	}

	public static func buildOptional(_ component: [LayoutGroup]?) -> [NSLayoutConstraint] {
		component?.flatMap { $0.constraints } ?? []
	}

	public static func buildEither(first component: [LayoutGroup]) -> [NSLayoutConstraint] {
		component.flatMap { $0.constraints }
	}

	public static func buildEither(second component: [LayoutGroup]) -> [NSLayoutConstraint] {
		component.flatMap { $0.constraints }
	}

}

public protocol LayoutGroup {

	var constraints: [NSLayoutConstraint] { get }

}

extension NSLayoutConstraint: LayoutGroup {

	public var constraints: [NSLayoutConstraint] { [self] }

}

extension Array: LayoutGroup where Element == NSLayoutConstraint {

	public var constraints: [NSLayoutConstraint] { self }

}
#endif
