#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

// MARK: - X Axis

public func +(lhs: NSLayoutXAxisAnchor, rhs: CGFloat) -> (NSLayoutXAxisAnchor, CGFloat) {
	return (lhs, rhs)
}

public func -(lhs: NSLayoutXAxisAnchor, rhs: CGFloat) -> (NSLayoutXAxisAnchor, CGFloat) {
	return (lhs, -rhs)
}

public func ==(lhs: NSLayoutXAxisAnchor, rhs: (NSLayoutXAxisAnchor, CGFloat)) -> NSLayoutConstraint {
	lhs.constraint(equalTo: rhs.0, constant: rhs.1)
}

public func ==(lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
	lhs.constraint(equalTo: rhs)
}

public func >=(lhs: NSLayoutXAxisAnchor, rhs: (NSLayoutXAxisAnchor, CGFloat)) -> NSLayoutConstraint {
	lhs.constraint(greaterThanOrEqualTo: rhs.0, constant: rhs.1)
}

public func >=(lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
	lhs.constraint(greaterThanOrEqualTo: rhs)
}

public func <=(lhs: NSLayoutXAxisAnchor, rhs: (NSLayoutXAxisAnchor, CGFloat)) -> NSLayoutConstraint {
	lhs.constraint(lessThanOrEqualTo: rhs.0, constant: rhs.1)
}

public func <=(lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
	lhs.constraint(lessThanOrEqualTo: rhs)
}

// MARK: - Y Axis

public func +(lhs: NSLayoutYAxisAnchor, rhs: CGFloat) -> (NSLayoutYAxisAnchor, CGFloat) {
	return (lhs, rhs)
}

public func -(lhs: NSLayoutYAxisAnchor, rhs: CGFloat) -> (NSLayoutYAxisAnchor, CGFloat) {
	return (lhs, -rhs)
}

public func ==(lhs: NSLayoutYAxisAnchor, rhs: (NSLayoutYAxisAnchor, CGFloat)) -> NSLayoutConstraint {
	lhs.constraint(equalTo: rhs.0, constant: rhs.1)
}

public func ==(lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
	lhs.constraint(equalTo: rhs)
}

public func >=(lhs: NSLayoutYAxisAnchor, rhs: (NSLayoutYAxisAnchor, CGFloat)) -> NSLayoutConstraint {
	lhs.constraint(greaterThanOrEqualTo: rhs.0, constant: rhs.1)
}

public func >=(lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
	lhs.constraint(greaterThanOrEqualTo: rhs)
}

public func <=(lhs: NSLayoutYAxisAnchor, rhs: (NSLayoutYAxisAnchor, CGFloat)) -> NSLayoutConstraint {
	lhs.constraint(lessThanOrEqualTo: rhs.0, constant: rhs.1)
}

public func <=(lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
	lhs.constraint(lessThanOrEqualTo: rhs)
}


// MARK: - Height

public func +(lhs: NSLayoutDimension, rhs: CGFloat) -> (NSLayoutDimension, CGFloat) {
	return (lhs, rhs)
}

public func -(lhs: NSLayoutDimension, rhs: CGFloat) -> (NSLayoutDimension, CGFloat) {
	return (lhs, -rhs)
}

public func ==(lhs: NSLayoutDimension, rhs: (NSLayoutDimension, CGFloat)) -> NSLayoutConstraint {
	lhs.constraint(equalTo: rhs.0, constant: rhs.1)
}

public func ==(lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint {
	lhs.constraint(equalTo: rhs)
}

public func >=(lhs: NSLayoutDimension, rhs: (NSLayoutDimension, CGFloat)) -> NSLayoutConstraint {
	lhs.constraint(greaterThanOrEqualTo: rhs.0, constant: rhs.1)
}

public func >=(lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint {
	lhs.constraint(greaterThanOrEqualTo: rhs)
}

public func <=(lhs: NSLayoutDimension, rhs: (NSLayoutDimension, CGFloat)) -> NSLayoutConstraint {
	lhs.constraint(lessThanOrEqualTo: rhs.0, constant: rhs.1)
}

public func <=(lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint {
	lhs.constraint(lessThanOrEqualTo: rhs)
}
