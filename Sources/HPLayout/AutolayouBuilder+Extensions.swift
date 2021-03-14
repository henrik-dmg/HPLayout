#if canImport(AppKit)
import AppKit
public typealias LayoutView = NSView
#endif

#if canImport(UIKit)
import UIKit
public typealias LayoutView = UIView
#endif

public extension LayoutView {

	// MARK: - Passed in view

	func addSubview(_ subview: LayoutView, @AutolayoutBuilder constraints: (LayoutView) -> [NSLayoutConstraint]) {
		addSubview(subview)
		subview.layout(constraints: constraints)
	}

	func layout(@AutolayoutBuilder constraints: (LayoutView) -> [NSLayoutConstraint]) {
		guard superview != nil else {
			print("[NOTE]: Could not activate constraints through AutolayoutBuilder since the view has no superview")
			return
		}
		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints(self))
	}

	// MARK: - No passed in view

	func addSubview(_ subview: LayoutView, @AutolayoutBuilder constraints: () -> [NSLayoutConstraint]) {
		addSubview(subview)
		subview.layout(constraints: constraints)
	}

	func layout(@AutolayoutBuilder constraints: () -> [NSLayoutConstraint]) {
		guard superview != nil else {
			print("[NOTE]: Could not activate constraints through AutolayoutBuilder since the view has no superview")
			return
		}
		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(constraints())
	}

}


