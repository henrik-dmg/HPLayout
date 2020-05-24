import Foundation
import UIKit

public enum LayoutGuide {
    case superview, readableContent, safeArea
}

public extension LayoutProxy {

    func verticallySpan(_ layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
        switch layoutGuide {
        case .superview:
            top == view.topAnchor + constant
            bottom == view.bottomAnchor - constant
        case .readableContent:
            top == view.readableContentGuide.topAnchor + constant
            bottom == view.readableContentGuide.bottomAnchor - constant
        case .safeArea:
            top == view.safeAreaLayoutGuide.topAnchor + constant
            bottom == view.safeAreaLayoutGuide.bottomAnchor - constant
        }
    }

    func horizontallySpan(_ layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
        switch layoutGuide {
        case .superview:
            leading == view.leadingAnchor + constant
            trailing == view.trailingAnchor - constant
        case .readableContent:
            leading == view.readableContentGuide.leadingAnchor + constant
            trailing == view.readableContentGuide.trailingAnchor - constant
        case .safeArea:
            leading == view.safeAreaLayoutGuide.leadingAnchor + constant
            trailing == view.safeAreaLayoutGuide.trailingAnchor - constant
        }
    }

    func span(_ layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
        verticallySpan(layoutGuide, constant: constant)
        horizontallySpan(layoutGuide, constant: constant)
    }

    func verticallyCenter(in layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
        switch layoutGuide {
        case .superview:
            centerY == view.centerYAnchor + constant
        case .readableContent:
            centerY == view.readableContentGuide.centerYAnchor + constant
        case .safeArea:
            centerY == view.safeAreaLayoutGuide.centerYAnchor + constant
        }
    }

    func horizontallyCenter(in layoutGuide: LayoutGuide, constant: CGFloat = 0.00) {
        switch layoutGuide {
        case .superview:
            centerX == view.centerXAnchor + constant
        case .readableContent:
            centerX == view.readableContentGuide.centerXAnchor + constant
        case .safeArea:
            centerX == view.safeAreaLayoutGuide.centerXAnchor + constant
        }
    }

    func center(in layoutGuide: LayoutGuide) {
        verticallyCenter(in: layoutGuide)
        horizontallyCenter(in: layoutGuide)
    }

}
