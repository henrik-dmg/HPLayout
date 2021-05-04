import XCTest
@testable import HPLayout
#if canImport(AppKit)
import AppKit
public typealias LayoutView = NSView
#endif

#if canImport(UIKit)
import UIKit
public typealias LayoutView = UIView
#endif

final class HPLayoutTests: XCTestCase {

	func testConstraints() {
		let test = LayoutView()
		test.layout {
			if let superView = test.superview {
				test.leadingAnchor == superView.trailingAnchor
			}
		}
	}
    
}
