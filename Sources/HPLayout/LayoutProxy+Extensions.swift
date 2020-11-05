import Foundation
import UIKit

public enum LayoutGuide {
    case superview, readableContent, safeArea, layoutMargins
}

public extension LayoutProxy {

    func spanVertically(_ layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
        guard let superview = view.superview else {
            return
        }

        switch layoutGuide {
        case .superview:
            top == superview.topAnchor + constant
            bottom == superview.bottomAnchor - constant
        case .readableContent:
            top == superview.readableContentGuide.topAnchor + constant
            bottom == superview.readableContentGuide.bottomAnchor - constant
        case .safeArea:
            top == superview.safeAreaLayoutGuide.topAnchor + constant
            bottom == superview.safeAreaLayoutGuide.bottomAnchor - constant
		case .layoutMargins:
			top == superview.layoutMarginsGuide.topAnchor + constant
			bottom == superview.layoutMarginsGuide.bottomAnchor - constant
        }
    }

    func spanHorizontally(_ layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
        guard let superview = view.superview else {
            return
        }

        switch layoutGuide {
        case .superview:
            leading == superview.leadingAnchor + constant
            trailing == superview.trailingAnchor - constant
        case .readableContent:
            leading == superview.readableContentGuide.leadingAnchor + constant
            trailing == superview.readableContentGuide.trailingAnchor - constant
        case .safeArea:
            leading == superview.safeAreaLayoutGuide.leadingAnchor + constant
            trailing == superview.safeAreaLayoutGuide.trailingAnchor - constant
		case .layoutMargins:
			leading == superview.layoutMarginsGuide.leadingAnchor + constant
			trailing == superview.layoutMarginsGuide.trailingAnchor - constant
        }
    }

    func span(_ layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
        spanVertically(layoutGuide, constant: constant)
        spanHorizontally(layoutGuide, constant: constant)
    }

    func centerVertically(in layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
        guard let superview = view.superview else {
            return
        }

        switch layoutGuide {
        case .superview:
            centerY == superview.centerYAnchor + constant
        case .readableContent:
            centerY == superview.readableContentGuide.centerYAnchor + constant
        case .safeArea:
            centerY == superview.safeAreaLayoutGuide.centerYAnchor + constant
		case .layoutMargins:
			centerY == superview.layoutMarginsGuide.centerYAnchor + constant
        }
    }

    func centerHorizontally(in layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
        guard let superview = view.superview else {
            return
        }

        switch layoutGuide {
        case .superview:
            centerX == superview.centerXAnchor + constant
        case .readableContent:
            centerX == superview.readableContentGuide.centerXAnchor + constant
        case .safeArea:
            centerX == superview.safeAreaLayoutGuide.centerXAnchor + constant
		case .layoutMargins:
			centerX == superview.layoutMarginsGuide.centerXAnchor + constant
        }
    }

    func center(in layoutGuide: LayoutGuide) {
        centerVertically(in: layoutGuide)
        centerHorizontally(in: layoutGuide)
    }

}
