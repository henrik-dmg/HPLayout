#if os(iOS) || os(tvOS)
import UIKit
#endif

#if os(OSX)
import AppKit
#endif

#if os(iOS) || os(OSX) || os(tvOS)
public extension NSLayoutConstraint {

	/// Activate the layouts defined in the result builder parameter `constraints`.
	static func activate(@AutolayoutBuilder constraints: () -> [NSLayoutConstraint]) {
		activate(constraints())
	}

}
#endif
