#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension NSLayoutConstraint {

	/// Activate the layouts defined in the result builder parameter `constraints`.
	static func activate(@AutolayoutBuilder constraints: () -> [NSLayoutConstraint]) {
		activate(constraints())
	}

}
