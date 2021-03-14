import XCTest
@testable import HPLayout

final class HPLayoutTests: XCTestCase {

	func testConstraints() {
		let view1 = UIView()
		let view2 = UIView()
		view1.addSubview(view2) { view in
			view.span(.safeArea)

			if Bool.random() {
				view.leadingAnchor == view1.leadingAnchor
			}

			view.span(.superview)
			view.leadingAnchor == view2.leadingAnchor
			view.heightAnchor == view1.heightAnchor
		}
	}
    
}
