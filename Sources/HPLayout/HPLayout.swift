import Foundation
import UIKit

private let separatorTag = 101

public class AutolayoutProxy: NSObject {

    // MARK: - Nested Types

    public enum SizeAttribute {
        case height
        case width
    }

    public enum SuperViewLayoutAttribute {
        public enum Alignment {
            case top, bottom, trailing, leading
        }

        case `super`(Alignment)
        case safeArea(Alignment)
        case readableContent(Alignment)
    }

    public enum AttributeType {
        case equal
        case greaterThanOrEqual
        case lessThanOrEqual
    }

    public enum StackingDistribution: Int {
        case fill
        case fillEqually
    }

    // MARK: - Default spacing constants

    private static let defaultHorizontalSpaceConstant: CGFloat =
        NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-[view]", options: [], metrics: [:], views: ["view": UIView()])[0].constant

    public static let defaultVerticalSpaceConstant: CGFloat =
        NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-[view]", options: [], metrics: [:], views: ["view": UIView()])[0].constant

    // MARK: - Properties

    let view: UIView
    public fileprivate(set) var lastConstraint: NSLayoutConstraint?

    // MARK: - Object Lifecycle

    init(view: UIView) {
        self.view = view
    }

    public class func layout(_ view: UIView) -> AutolayoutProxy {
        view.translatesAutoresizingMaskIntoConstraints = false
        return AutolayoutProxy(view: view)
    }

    // MARK: - Stacking

    public class func stackViewsHorizontally(_ views: [UIView], spacing: CGFloat) {
        stackViewsAndSeparatorsHorizontally(views, distribution: .fill, spacing: spacing)
    }

    public class func stackViewsHorizontally(_ views: [UIView], distribution: StackingDistribution, spacing: CGFloat) {
        stackViewsAndSeparatorsHorizontally(views, distribution: distribution, spacing: spacing)
    }

    public class func stackViewsHorizontally(
        _ views: [UIView],
        distribution: StackingDistribution,
        spacing: CGFloat,
        separatorWidth: CGFloat,
        separatorColor: UIColor?,
        enclosingSeparators: Bool) -> [UIView] {
            guard let separatorColor = separatorColor, separatorWidth > 0 else {
                stackViewsHorizontally(views, distribution: distribution, spacing: spacing)
                return []
            }

            var separators = [UIView]()
            var viewsAndSeparators = [UIView]()

            for view in views {
                if view === views.first && enclosingSeparators {
                    let separator = injectVerticalSeparator(separatorWidth, color: separatorColor, referenceView: view)
                    separators.append(separator)
                    viewsAndSeparators.append(separator)
                }

                viewsAndSeparators.append(view)

                if view !== views.last || enclosingSeparators {
                    let separator = injectVerticalSeparator(separatorWidth, color: separatorColor, referenceView: view)
                    separators.append(separator)
                    viewsAndSeparators.append(separator)
                }
            }

            stackViewsAndSeparatorsHorizontally(viewsAndSeparators, distribution: distribution, spacing: spacing)
            return separators
    }

    fileprivate class func stackViewsAndSeparatorsHorizontally(
        _ viewsAndSeparators: [UIView],
        distribution: StackingDistribution,
        spacing: CGFloat) {
        var previousViewOrSeparator: UIView?
        var previousView: UIView?

        for viewOrSeparator in viewsAndSeparators {
            let autolayoutProxy = AutolayoutProxy.layout(viewOrSeparator)
            autolayoutProxy.verticallySpanSuperview()

            if let previousViewOrSeparator = previousViewOrSeparator {
                autolayoutProxy.leadingSpaceTo(previousViewOrSeparator, value: spacing)
            } else {
                autolayoutProxy.leadingSpaceToSuperview()
            }

            if viewOrSeparator === viewsAndSeparators.last {
                autolayoutProxy.trailingSpaceToSuperview()
            }

            if let previousView = previousView, viewOrSeparator.tag != separatorTag {
                switch distribution {
                case .fill:
                    break
                case .fillEqually:
                    autolayoutProxy.widthEqualTo(previousView)
                }
            }

            previousViewOrSeparator = viewOrSeparator
            if viewOrSeparator.tag != separatorTag {
                previousView = viewOrSeparator
            }
        }
    }

    public class func stackViewsVertically(_ views: [UIView], spacing: CGFloat) {
        stackViewsVertically(views, distribution: .fill, spacing: spacing)
    }

    public class func stackViewsVertically(_ views: [UIView], distribution: StackingDistribution, spacing: CGFloat) {
        stackViewsAndSeparatorsVertically(views, distribution: distribution, spacing: spacing)
    }

    @discardableResult public class func stackViewsVertically(
        _ views: [UIView],
        distribution: StackingDistribution,
        spacing: CGFloat,
        separatorHeight: CGFloat,
        separatorColor: UIColor?,
        enclosingSeparators: Bool) -> [UIView] {
            guard let separatorColor = separatorColor, separatorHeight > 0 else {
                stackViewsHorizontally(views, distribution: distribution, spacing: spacing)
                return []
            }

            var separators = [UIView]()
            var viewsAndSeparators = [UIView]()

            for view in views {
                if view === views.first && enclosingSeparators {
                    let separator = injectHorizontalSeparator(separatorHeight, color: separatorColor, referenceView: view)
                    separators.append(separator)
                    viewsAndSeparators.append(separator)
                }

                viewsAndSeparators.append(view)

                if view !== views.last || enclosingSeparators {
                    let separator = injectHorizontalSeparator(separatorHeight, color: separatorColor, referenceView: view)
                    separators.append(separator)
                    viewsAndSeparators.append(separator)
                }
            }

            stackViewsAndSeparatorsVertically(viewsAndSeparators, distribution: distribution, spacing: spacing)
            return separators
    }

    fileprivate class func stackViewsAndSeparatorsVertically(
        _ viewsAndSeparators: [UIView],
        distribution: StackingDistribution,
        spacing: CGFloat) {
        var previousViewOrSeparator: UIView?
        var previousView: UIView?

        for viewOrSeparator in viewsAndSeparators {
            let autolayoutProxy = AutolayoutProxy.layout(viewOrSeparator)
            autolayoutProxy.horizontallySpanSuperview()

            if let previousViewOrSeparator = previousViewOrSeparator {
                autolayoutProxy.topSpaceTo(previousViewOrSeparator, value: spacing)
            } else {
                autolayoutProxy.topSpaceToSuperview()
            }

            if viewOrSeparator === viewsAndSeparators.last {
                autolayoutProxy.bottomSpaceToSuperview()
            }

            if let previousView = previousView, viewOrSeparator.tag != separatorTag {
                switch distribution {
                case .fill:
                    break
                case .fillEqually:
                    autolayoutProxy.heightEqualTo(previousView)
                }
            }

            previousViewOrSeparator = viewOrSeparator
            if viewOrSeparator.tag != separatorTag {
                previousView = viewOrSeparator
            }
        }
    }

    fileprivate class func injectVerticalSeparator(_ width: CGFloat, color: UIColor, referenceView: UIView) -> UIView {
        let separator = injectSeparator(color, referenceView: referenceView)
        separator.setContentCompressionResistancePriority(.required, for: .horizontal)
        separator.setContentHuggingPriority(.required, for: .horizontal)
        AutolayoutProxy.layout(separator).width(width).alignTopToTopOf(referenceView).alignBottomToBottomOf(referenceView)
        return separator
    }

    fileprivate class func injectHorizontalSeparator(_ height: CGFloat, color: UIColor, referenceView: UIView) -> UIView {
        let separator = injectSeparator(color, referenceView: referenceView)
        separator.setContentCompressionResistancePriority(.required, for: .vertical)
        separator.setContentHuggingPriority(.required, for: .vertical)
        AutolayoutProxy.layout(separator).height(height).alignLeadingToLeadingOf(referenceView).alignTrailingToTrailingOf(referenceView)
        return separator
    }

    fileprivate class func injectSeparator(_ color: UIColor, referenceView: UIView) -> UIView {
        let separator = UIView()
        separator.tag = separatorTag
        separator.backgroundColor = color
        referenceView.superview?.addSubview(separator)
        return separator
    }

    // MARK: - Spanning SuperView

    @discardableResult public func spanSuperview(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        horizontallySpanSuperview(value, priority: priority)
        verticallySpanSuperview(value, priority: priority)
        lastConstraint = nil
        return self
    }

    @discardableResult public func horizontallySpanSuperview(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        constraintToSuperView(.equal, attribute: .super(.leading), value, priority: priority)
        constraintToSuperView(.equal, attribute: .super(.trailing), -value, priority: priority)
        lastConstraint = nil
        return self
    }

    @discardableResult public func verticallySpanSuperview(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        constraintToSuperView(.equal, attribute: .super(.top), value, priority: priority)
        constraintToSuperView(.equal, attribute: .super(.bottom), -value, priority: priority)
        lastConstraint = nil
        return self
    }

    // MARK: - Spanning Safe Area

    @discardableResult public func spanSafeArea(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        horizontallySpanSafeArea(value, priority: priority)
        verticallySpanSafeArea(value, priority: priority)
        lastConstraint = nil
        return self
    }

    @discardableResult public func horizontallySpanSafeArea(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        constraintToSuperView(.equal, attribute: .safeArea(.leading), value, priority: priority)
            constraintToSuperView(.equal, attribute: .safeArea(.trailing), value, priority: priority)
        lastConstraint = nil
        return self
    }

    @discardableResult public func verticallySpanSafeArea(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        constraintToSuperView(.equal, attribute: .safeArea(.top), value, priority: priority)
            constraintToSuperView(.equal, attribute: .safeArea(.bottom), value, priority: priority)
        lastConstraint = nil
        return self
    }

    // MARK: - Spanning Readable Content Guide

    @discardableResult public func spanReadableContent(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        horizontallySpanReadableContent(value, priority: priority)
        verticallySpanReadableContent(value, priority: priority)
        lastConstraint = nil
        return self
    }

    @discardableResult public func horizontallySpanReadableContent(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        constraintToSuperView(.equal, attribute: .readableContent(.leading), value, priority: priority)
            constraintToSuperView(.equal, attribute: .readableContent(.trailing), value, priority: priority)
        lastConstraint = nil
        return self
    }

    @discardableResult public func verticallySpanReadableContent(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        constraintToSuperView(.equal, attribute: .readableContent(.top), value, priority: priority)
            constraintToSuperView(.equal, attribute: .readableContent(.bottom), value, priority: priority)
        lastConstraint = nil
        return self
    }

    // MARK: - Other View Spacing

    @discardableResult public func constraint(_ attribute: SuperViewLayoutAttribute.Alignment, _ value: CGFloat = 0.0, _ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        switch attribute {
        case .leading:
            addConstraintRelativeTo(other, priority: priority) {
                view.leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: value)
            }
            return self
        case .trailing:
            addConstraintRelativeTo(other, priority: priority) {
                view.trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: value)
            }
            return self
        case .top:
            addConstraintRelativeTo(other, priority: priority) {
                view.topAnchor.constraint(equalTo: other.topAnchor, constant: value)
            }
            return self
        case .bottom:
            addConstraintRelativeTo(other, priority: priority) {
                view.bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: value)
            }
            return self
        }
    }

    // MARK: - SuperView Spacing

    @discardableResult public func constraintToSuperView(_ type: AttributeType = .equal, attribute: SuperViewLayoutAttribute, _ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        switch type {
        case .equal:
            return constraintToSuperViewEqual(attribute, value: value, priority: priority)
        case .lessThanOrEqual:
            return constraintToSuperViewLessThanOrEqual(attribute, value: value, priority: priority)
        case .greaterThanOrEqual:
            return constraintToSuperViewGreaterThanOrEqual(attribute, value: value, priority: priority)
        }
    }

    // MARK: - Equal
    @discardableResult private func constraintToSuperViewEqual(_ attribute: SuperViewLayoutAttribute, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        switch attribute {
        case .super(let alignment):
            switch alignment {
            case .leading:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: value)
                }
                return self
            case .trailing:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: value)
                }
                return self
            case .top:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: value)
                }
                return self
            case .bottom:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: value)
                }
                return self
            }
        case .safeArea(let alignment):
            switch alignment {
            case .leading:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: value)
                }
                return self
            case .trailing:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: value)
                }
                return self
            case .top:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: value)
                }
                return self
            case .bottom:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: value)
                }
                return self
            }
        case .readableContent(let alignment):
            switch alignment {
            case .leading:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.leadingAnchor.constraint(equalTo: superview.readableContentGuide.leadingAnchor, constant: value)
                }
                return self
            case .trailing:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.trailingAnchor.constraint(equalTo: superview.readableContentGuide.trailingAnchor, constant: value)
                }
                return self
            case .top:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.topAnchor.constraint(equalTo: superview.readableContentGuide.topAnchor, constant: value)
                }
                return self
            case .bottom:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.bottomAnchor.constraint(equalTo: superview.readableContentGuide.bottomAnchor, constant: value)
                }
                return self
            }
        }
    }

    // MARK: - LessThanOrEqual
    @discardableResult private func constraintToSuperViewLessThanOrEqual(_ attribute: SuperViewLayoutAttribute, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        switch attribute {
        case .super(let alignment):
            switch alignment {
            case .leading:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.leadingAnchor.constraint(lessThanOrEqualTo: superview.leadingAnchor, constant: value)
                }
                return self
            case .trailing:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor, constant: value)
                }
                return self
            case .top:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.topAnchor.constraint(lessThanOrEqualTo: superview.topAnchor, constant: value)
                }
                return self
            case .bottom:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.bottomAnchor.constraint(lessThanOrEqualTo: superview.bottomAnchor, constant: value)
                }
                return self
            }
        case .safeArea(let alignment):
            switch alignment {
            case .leading:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.leadingAnchor.constraint(lessThanOrEqualTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: value)
                }
                return self
            case .trailing:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.trailingAnchor.constraint(lessThanOrEqualTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: value)
                }
                return self
            case .top:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.topAnchor.constraint(lessThanOrEqualTo: superview.safeAreaLayoutGuide.topAnchor, constant: value)
                }
                return self
            case .bottom:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.bottomAnchor.constraint(lessThanOrEqualTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: value)
                }
                return self
            }
        case .readableContent(let alignment):
            switch alignment {
            case .leading:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.leadingAnchor.constraint(lessThanOrEqualTo: superview.readableContentGuide.leadingAnchor, constant: value)
                }
                return self
            case .trailing:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.trailingAnchor.constraint(lessThanOrEqualTo: superview.readableContentGuide.trailingAnchor, constant: value)
                }
                return self
            case .top:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.topAnchor.constraint(lessThanOrEqualTo: superview.readableContentGuide.topAnchor, constant: value)
                }
                return self
            case .bottom:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.bottomAnchor.constraint(lessThanOrEqualTo: superview.readableContentGuide.bottomAnchor, constant: value)
                }
                return self
            }
        }
    }

    // MARK: - GreaterThanOrEqual
    @discardableResult private func constraintToSuperViewGreaterThanOrEqual(_ attribute: SuperViewLayoutAttribute, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        switch attribute {
        case .super(let alignment):
            switch alignment {
            case .leading:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: value)
                }
                return self
            case .trailing:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.trailingAnchor.constraint(greaterThanOrEqualTo: superview.trailingAnchor, constant: value)
                }
                return self
            case .top:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: value)
                }
                return self
            case .bottom:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.bottomAnchor.constraint(greaterThanOrEqualTo: superview.bottomAnchor, constant: value)
                }
                return self
            }
        case .safeArea(let alignment):
            switch alignment {
            case .leading:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.leadingAnchor.constraint(greaterThanOrEqualTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: value)
                }
                return self
            case .trailing:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.trailingAnchor.constraint(greaterThanOrEqualTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: value)
                }
                return self
            case .top:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.topAnchor.constraint(greaterThanOrEqualTo: superview.safeAreaLayoutGuide.topAnchor, constant: value)
                }
                return self
            case .bottom:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.bottomAnchor.constraint(greaterThanOrEqualTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: value)
                }
                return self
            }
        case .readableContent(let alignment):
            switch alignment {
            case .leading:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.leadingAnchor.constraint(greaterThanOrEqualTo: superview.readableContentGuide.leadingAnchor, constant: value)
                }
                return self
            case .trailing:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.trailingAnchor.constraint(greaterThanOrEqualTo: superview.readableContentGuide.trailingAnchor, constant: value)
                }
                return self
            case .top:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.topAnchor.constraint(greaterThanOrEqualTo: superview.readableContentGuide.topAnchor, constant: value)
                }
                return self
            case .bottom:
                addConstraintRelativeToSuperview(priority: priority) { superview in
                    view.bottomAnchor.constraint(greaterThanOrEqualTo: superview.readableContentGuide.bottomAnchor, constant: value)
                }
                return self
            }
        }
    }

    @discardableResult public func leadingSpaceToSuperview(_ value: CGFloat = 0.0, type: AttributeType = .equal, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        switch type {
        case .equal:
            addConstraintRelativeToSuperview(priority: priority) { superview in
                view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: value)
            }
        case .greaterThanOrEqual:
            addConstraintRelativeToSuperview(priority: priority) { superview in
                view.leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: value)
            }
        case .lessThanOrEqual:
            addConstraintRelativeToSuperview(priority: priority) { superview in
                view.leadingAnchor.constraint(lessThanOrEqualTo: superview.leadingAnchor, constant: value)
            }
        }
        return self
    }

    @discardableResult public func leadingSpaceToSuperviewReadableContentGuide(
        _ value: CGFloat = 0.0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            view.leadingAnchor.constraint(equalTo: superview.readableContentGuide.leadingAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func defaultLeadingSpaceTo(_ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        return leadingSpaceTo(other, value: AutolayoutProxy.defaultHorizontalSpaceConstant, priority: priority)
    }

    @discardableResult public func leadingSpaceTo(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.leadingAnchor.constraint(equalTo: other.trailingAnchor, constant: value) }
        return self
    }

    @discardableResult public func leadingSpaceTo(_ other: UIView, greaterOrEqual value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.leadingAnchor.constraint(greaterThanOrEqualTo: other.trailingAnchor, constant: value) }
        return self
    }

    @discardableResult public func defaultTrailingSpaceToSuperview(priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            superview.layoutMarginsGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        }
        return self
    }

    @discardableResult public func trailingSpaceToSuperview(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            superview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func trailingSpaceToSuperview(greaterOrEqual value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            superview.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func trailingSpaceToSuperviewReadableContentGuide(
        _ value: CGFloat = 0.0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            superview.readableContentGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func defaultTrailingSpaceTo(_ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        return trailingSpaceTo(other, value: AutolayoutProxy.defaultHorizontalSpaceConstant, priority: priority)
    }

    @discardableResult public func trailingSpaceTo(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { other.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: value) }
        return self
    }

    @discardableResult public func trailingSpaceTo(_ other: UIView, greaterOrEqual value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { other.leadingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: value) }
        return self
    }

    // MARK: - Top & Bottom Space

    @discardableResult public func defaultTopSpaceToSuperview(priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            view.topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor)
        }
        return self
    }

    @discardableResult public func topSpaceToSuperview(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            view.topAnchor.constraint(equalTo: superview.topAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func topSpaceToSuperview(greaterOrEqual value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func defaultTopSpaceTo(_ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        return topSpaceTo(other, value: AutolayoutProxy.defaultVerticalSpaceConstant, priority: priority)
    }

    @discardableResult public func topSpaceTo(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.topAnchor.constraint(equalTo: other.bottomAnchor, constant: value) }
        return self
    }

    @discardableResult public func topSpaceTo(_ other: UIView, greaterOrEqual value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.topAnchor.constraint(greaterThanOrEqualTo: other.bottomAnchor, constant: value) }
        return self
    }

    @discardableResult public func defaultBottomSpaceToSuperview(priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            superview.layoutMarginsGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
        return self
    }

    @discardableResult public func bottomSpaceToSuperview(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            superview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func bottomSpaceToSuperview(greaterOrEqual value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            superview.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func bottomSpaceToSuperview(lessThanOrEqualTo value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            superview.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func defaultBottomSpaceTo(_ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        return bottomSpaceTo(other, value: AutolayoutProxy.defaultVerticalSpaceConstant, priority: priority)
    }

    @discardableResult public func bottomSpaceTo(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { other.topAnchor.constraint(equalTo: view.bottomAnchor, constant: value) }
        return self
    }

    @discardableResult public func bottomSpaceTo(_ other: UIView, greaterOrEqual value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { other.topAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: value) }
        return self
    }

    // MARK: - Centering

    @discardableResult public func centerHorizontallyInSuperview(_ value: CGFloat = 0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func centerHorizontallyIn(_ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.centerXAnchor.constraint(equalTo: other.centerXAnchor) }
        return self
    }

    @discardableResult public func centerVerticallyInSuperview(_ value: CGFloat = 0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func centerVerticallyInSuperviewSafeArea(_ value: CGFloat = 0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            view.centerYAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.centerYAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func centerVerticallyIn(_ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.centerYAnchor.constraint(equalTo: other.centerYAnchor) }
        return self
    }

    // MARK: - Width & Height

    @discardableResult public func size(_ size: CGSize, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        return width(size.width, priority: priority).height(size.height, priority: priority)
    }

    @discardableResult public func width(_ value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraint(view.widthAnchor.constraint(equalToConstant: value), priority: priority)
        return self
    }

    @discardableResult public func widthGreater(_ value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraint(view.widthAnchor.constraint(greaterThanOrEqualToConstant: value), priority: priority)
        return self
    }

    @discardableResult public func widthSmaller(_ value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraint(view.widthAnchor.constraint(lessThanOrEqualToConstant: value), priority: priority)
        return self
    }

    @discardableResult public func widthEqualToSuperview(
        _ value: CGFloat = 0.0,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: multiplier, constant: value)
        }
        return self
    }

    @discardableResult public func widthSmallerOrEqualToSuperview(_ value: CGFloat = 0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            view.widthAnchor.constraint(lessThanOrEqualTo: superview.widthAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func widthEqualTo(
        _ other: UIView,
        multiplier: CGFloat = 1,
        value: CGFloat = 0.0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.widthAnchor.constraint(equalTo: other.widthAnchor, multiplier: multiplier, constant: value) }
        return self
    }

    @discardableResult public func widthEqualToHeightOf(_ other: UIView, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.widthAnchor.constraint(equalTo: other.heightAnchor, multiplier: multiplier) }
        return self
    }

    @discardableResult public func widthGreaterOrEqualTo(_ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.widthAnchor.constraint(greaterThanOrEqualTo: other.widthAnchor) }
        return self
    }

    @discardableResult public func widthSmallerOrEqualTo(_ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.widthAnchor.constraint(lessThanOrEqualTo: other.widthAnchor) }
        return self
    }

    @discardableResult public func height(_ value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraint(view.heightAnchor.constraint(equalToConstant: value), priority: priority)
        return self
    }

    @discardableResult public func heightGreater(_ value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraint(view.heightAnchor.constraint(greaterThanOrEqualToConstant: value), priority: priority)
        return self
    }

    @discardableResult public func heightLess(_ value: CGFloat, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraint(view.heightAnchor.constraint(lessThanOrEqualToConstant: value), priority: priority)
        return self
    }

    @discardableResult public func heightEqualToSuperview(multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            view.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: multiplier)
        }
        return self
    }

    @discardableResult public func heightSmallerOrEqualToSuperview(_ value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeToSuperview(priority: priority) { superview in
            view.heightAnchor.constraint(lessThanOrEqualTo: superview.heightAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func heightEqualTo(
        _ other: UIView,
        multiplier: CGFloat = 1,
        value: CGFloat = 0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(
            other,
            priority: priority, {
                view.heightAnchor.constraint(equalTo: other.heightAnchor, multiplier: multiplier, constant: value)
            })
        return self
    }

    @discardableResult public func heightGreaterOrEqualTo(_ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.heightAnchor.constraint(greaterThanOrEqualTo: other.heightAnchor) }
        return self
    }

    @discardableResult public func heightSmallerOrEqualTo(_ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.heightAnchor.constraint(lessThanOrEqualTo: other.heightAnchor) }
        return self
    }

    @discardableResult public func heightEqualToWidth(multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraint(view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier), priority: priority)
        return self
    }

    @discardableResult public func widthEqualToHeight(multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraint(view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier), priority: priority)
        return self
    }

    // MARK: - Alignment

    @discardableResult public func alignBaselineToBaselineOf(_ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.lastBaselineAnchor.constraint(equalTo: other.lastBaselineAnchor) }
        return self
    }

    @discardableResult public func alignBottomToBaselineOf(_ other: UIView, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.bottomAnchor.constraint(equalTo: other.lastBaselineAnchor) }
        return self
    }

    @discardableResult public func alignBottomToBottomOf(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: value) }
        return self
    }

    @discardableResult public func alignBottomToCenterOf(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.bottomAnchor.constraint(equalTo: other.centerYAnchor, constant: value) }
        return self
    }

    @discardableResult public func alignBottomToTopOf(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.bottomAnchor.constraint(equalTo: other.topAnchor, constant: value) }
        return self
    }

    @discardableResult public func alignTopToBottomOf(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.topAnchor.constraint(equalTo: other.bottomAnchor, constant: value) }
        return self
    }

    @discardableResult public func alignLeadingToLeadingOf(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: value) }
        return self
    }

    @discardableResult public func alignLeadingToTrailingOf(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.leadingAnchor.constraint(equalTo: other.trailingAnchor, constant: value) }
        return self
    }

    @discardableResult public func alignTrailingToTrailingOf(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: value) }
        return self
    }

    @discardableResult public func alignTopToTopOf(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.topAnchor.constraint(equalTo: other.topAnchor, constant: value) }
        return self
    }

    @discardableResult public func alignTopToCenterOf(_ other: UIView, value: CGFloat = 0.0, priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) { view.topAnchor.constraint(equalTo: other.centerYAnchor, constant: value) }
        return self
    }

    // MARK: - Safe Area Constraints

    @discardableResult public func alignBottomToSafeAreaLayoutGuideBottomAnchorOf(
        _ other: UIView,
        value: CGFloat = 0.0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) {
            view.bottomAnchor.constraint(equalTo: other.safeAreaLayoutGuide.bottomAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func alignBottomToSafeAreaLayoutGuideBottomAnchorOf(
        _ controller: UIViewController,
        value: CGFloat = 0.0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(controller.view, priority: priority) {
            view.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func alignBottomLessThanOrEqualToSafeAreaLayoutGuideBottomAnchorOf(
        _ other: UIView,
        value: CGFloat = 0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) {
            view.bottomAnchor.constraint(lessThanOrEqualTo: other.safeAreaLayoutGuide.bottomAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func alignTopToSafeAreaLayoutGuideTopAnchorOf(
        _ other: UIView,
        value: CGFloat = 0.0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) {
            view.topAnchor.constraint(equalTo: other.safeAreaLayoutGuide.topAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func alignTopToSafeAreaLayoutGuideTopAnchorOf(
        _ controller: UIViewController,
        value: CGFloat = 0.0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(controller.view, priority: priority) {
            view.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func alignLeadingToSafeAreaLeadingAnchorOf(
        _ other: UIView,
        value: CGFloat = 0.0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) {
            view.leadingAnchor.constraint(equalTo: other.safeAreaLayoutGuide.leadingAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func alignLeadingToSafeAreaLeadingAnchorOf(
        _ controller: UIViewController,
        value: CGFloat = 0.0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(controller.view, priority: priority) {
            view.leadingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.leadingAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func alignTrailingToSafeAreaTrailingAnchorOf(
        _ other: UIView,
        value: CGFloat = 0.0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(other, priority: priority) {
            view.trailingAnchor.constraint(equalTo: other.safeAreaLayoutGuide.trailingAnchor, constant: value)
        }
        return self
    }

    @discardableResult public func alignTrailingToSafeAreaTrailingAnchorOf(
        _ controller: UIViewController,
        value: CGFloat = 0.0,
        priority: UILayoutPriority = .required) -> AutolayoutProxy {
        addConstraintRelativeTo(controller.view, priority: priority) {
            view.trailingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.trailingAnchor, constant: value)
        }
        return self
    }

    // MARK: - Remove Constraint Helpers

    @discardableResult public func resetConstraintsToSuperview() -> AutolayoutProxy {
        guard let superview = view.superview else {
            return self
        }

        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? NSObject, firstItem == view {
                superview.removeConstraint(constraint)
                continue
            }
            if let secondItem = constraint.secondItem as? NSObject, secondItem == view {
                superview.removeConstraint(constraint)
            }
        }

        return self
    }

    // MARK: - Private Helpers

    fileprivate func closestCommonAncestor(_ view: UIView, _ other: UIView) -> UIView? {
        var superviews = Set<UIView>()
        var superview: UIView?

        // Collect all superviews of first view
        superview = view
        while let theSuperview = superview {
            superviews.insert(theSuperview)
            superview = theSuperview.superview
        }

        // Find closest superview of second view that is a superview of the first view
        superview = other
        while let theSuperview = superview {
            if superviews.contains(theSuperview) {
                return theSuperview
            }
            superview = theSuperview.superview
        }

        return nil // No common superview found
    }

    fileprivate func addConstraintRelativeToSuperview(priority: UILayoutPriority, _ makeConstraintUsingSuperview: (UIView) -> NSLayoutConstraint) {
        if let superview = view.superview {
            addConstraint(makeConstraintUsingSuperview(superview), priority: priority)
        } else {
            lastConstraint = nil
        }
    }

    fileprivate func addConstraintRelativeTo(_ other: UIView, priority: UILayoutPriority, _ makeConstraint: () -> NSLayoutConstraint) {
        if closestCommonAncestor(view, other) != nil {
            addConstraint(makeConstraint(), priority: priority)
        } else {
            lastConstraint = nil
        }
    }

    fileprivate func addConstraint(_ constraint: NSLayoutConstraint, priority: UILayoutPriority) {
        constraint.priority = priority
        NSLayoutConstraint.activate([constraint])
        lastConstraint = constraint
    }

}
