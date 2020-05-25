import Foundation
import UIKit

public enum LayoutGuide {
    case superview, readableContent, safeArea
}

public extension LayoutProxy {

    func verticallySpan(_ layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
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
        }
    }

    func horizontallySpan(_ layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
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
        }
    }

    func span(_ layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
        verticallySpan(layoutGuide, constant: constant)
        horizontallySpan(layoutGuide, constant: constant)
    }

    func verticallyCenter(in layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
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
        }
    }

    func horizontallyCenter(in layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
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
        }
    }

    func center(in layoutGuide: LayoutGuide) {
        verticallyCenter(in: layoutGuide)
        horizontallyCenter(in: layoutGuide)
    }

}
