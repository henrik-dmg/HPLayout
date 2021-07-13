#if os(iOS) || os(tvOS)
import UIKit

public enum LayoutGuide {
    case superview, readableContent, safeArea, layoutMargins
}

public extension UIView {

	// MARK: - Spanning

	func spanVertically(_ layoutGuide: LayoutGuide, constant: CGFloat = 0.00) -> [NSLayoutConstraint] {
		guard let superview = superview else {
			return []
		}

		switch layoutGuide {
		case .superview:
			return [
				topAnchor.constraint(equalTo: superview.topAnchor, constant: constant),
				bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant)
			]
		case .readableContent:
			return spanVertically(superview.readableContentGuide, constant: constant)
		case .safeArea:
			return spanVertically(superview.safeAreaLayoutGuide, constant: constant)
		case .layoutMargins:
			return spanVertically(superview.layoutMarginsGuide, constant: constant)
		}
	}

	private func spanVertically(_ guide: UILayoutGuide, constant: CGFloat) -> [NSLayoutConstraint] {
		[
			topAnchor.constraint(equalTo: guide.topAnchor, constant: constant),
			bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -constant)
		]
	}

	func spanHorizontally(_ layoutGuide: LayoutGuide, constant: CGFloat = 0.00) -> [NSLayoutConstraint] {
		guard let superview = superview else {
			return []
		}

		switch layoutGuide {
		case .superview:
			return [
				leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant),
				trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant)
			]
		case .readableContent:
			return spanHorizontally(superview.readableContentGuide, constant: constant)
		case .safeArea:
			return spanHorizontally(superview.safeAreaLayoutGuide, constant: constant)
		case .layoutMargins:
			return spanHorizontally(superview.layoutMarginsGuide, constant: constant)
		}
	}

	private func spanHorizontally(_ guide: UILayoutGuide, constant: CGFloat) -> [NSLayoutConstraint] {
		[
			leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: constant),
			trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -constant)
		]
	}

	func span(_ layoutGuide: LayoutGuide, constant: CGFloat = 0.00) -> [NSLayoutConstraint] {
		spanVertically(layoutGuide, constant: constant) + spanHorizontally(layoutGuide, constant: constant)
	}

	// MARK: - Centering

	func centerVertically(in layoutGuide: LayoutGuide, constant: CGFloat = 0.00) -> [NSLayoutConstraint] {
		guard let superview = superview else {
			return []
		}

		switch layoutGuide {
		case .superview:
			return [centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: constant)]
		case .readableContent:
			return [centerYAnchor.constraint(equalTo: superview.readableContentGuide.centerYAnchor, constant: constant)]
		case .safeArea:
			return [centerYAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.centerYAnchor, constant: constant)]
		case .layoutMargins:
			return [centerYAnchor.constraint(equalTo: superview.layoutMarginsGuide.centerYAnchor, constant: constant)]
		}
	}

	func centerHorizontally(in layoutGuide: LayoutGuide, constant: CGFloat = 0.00) -> [NSLayoutConstraint] {
		guard let superview = superview else {
			return []
		}

		switch layoutGuide {
		case .superview:
			return [centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: constant)]
		case .readableContent:
			return [centerXAnchor.constraint(equalTo: superview.readableContentGuide.centerXAnchor, constant: constant)]
		case .safeArea:
			return [centerXAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.centerXAnchor, constant: constant)]
		case .layoutMargins:
			return [centerXAnchor.constraint(equalTo: superview.layoutMarginsGuide.centerXAnchor, constant: constant)]
		}
	}

	func center(in layoutGuide: LayoutGuide) -> [NSLayoutConstraint] {
		centerVertically(in: layoutGuide) + centerHorizontally(in: layoutGuide)
	}

}
#endif
