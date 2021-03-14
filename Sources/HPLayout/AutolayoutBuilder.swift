import Foundation
import UIKit

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

public extension NSLayoutConstraint {

	/// Activate the layouts defined in the result builder parameter `constraints`.
	static func activate(@AutolayoutBuilder constraints: () -> [NSLayoutConstraint]) {
		activate(constraints())
	}

}

public extension UIView {

	func addSubview(_ subview: UIView, @AutolayoutBuilder constraints: (UIView) -> [NSLayoutConstraint]) {
		addSubview(subview)
		subview.layout(constraints: constraints)
	}

	func layout(@AutolayoutBuilder constraints: (UIView) -> [NSLayoutConstraint]) {
		guard superview != nil else {
			print("[NOTE]: Could not activate constraints through AutolayoutBuilder since the view has no superview")
			return
		}
		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints(self))
	}

}
