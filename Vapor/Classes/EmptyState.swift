//
//  EmptyState.swift
//  Pods
//
//  Created by Nicholas Bonatsakis on 11/28/16.
//
//

import UIKit

// MARK: Model

public struct EmptyState: Equatable {

    let message: String?
    let image: UIImage?
    let action: EmptyStateAction?

    public init(message: String?, image: UIImage?, action: EmptyStateAction?) {
        self.message = message
        self.image = image
        self.action = action
    }

    public static func ==(lhs: EmptyState, rhs: EmptyState) -> Bool {
        return
            lhs.message == rhs.message &&
            lhs.image == rhs.image &&
            lhs.action == rhs.action
    }
}

public typealias EmptyStateActionHandler = () -> Void

public struct EmptyStateAction: Equatable {

    let title: String
    let handler: EmptyStateActionHandler?

    public init(title: String, handler: EmptyStateActionHandler?) {
        self.title = title
        self.handler = handler
    }

    public static func ==(lhs: EmptyStateAction, rhs: EmptyStateAction) -> Bool {
        return lhs.title == rhs.title
    }
}

// MARK: UIKit

public class EmptyStateView: UIView {

    // MARK: Subviews

    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.tintColor = .lightGray
        return imageView
    }()

    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        return button
    }()

    let stackView: UIStackView = UIStackView()

    // MARK: UIAppearance

    public dynamic var imageTintColor: UIColor {
        get { return imageView.tintColor }
        set { imageView.tintColor = newValue }
    }

    public dynamic var messageFont: UIFont {
        get { return messageLabel.font }
        set { messageLabel.font = newValue }
    }

    public dynamic var messageTextColor: UIColor {
        get { return messageLabel.textColor }
        set { messageLabel.textColor = newValue }
    }

    public dynamic var actionFont: UIFont? {
        get { return actionButton.titleLabel?.font }
        set { actionButton.titleLabel?.font = newValue }
    }

    public dynamic var actionTintColor: UIColor {
        get { return actionButton.tintColor }
        set { actionButton.tintColor = newValue }
    }

    // MARK: Init

    let emptyState: EmptyState

    public init(emptyState: EmptyState) {
        self.emptyState = emptyState
        super.init(frame: .zero)

        messageLabel.text = emptyState.message
        imageView.image = emptyState.image
        if let action = emptyState.action {
            actionButton.setTitle(action.title, for: .normal)
            actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        }

        addSubview(stackView)
        configureStackView()
        configureLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // /MARK: Config

    func configureLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    func configureStackView() {
        if imageView.image != nil {
            stackView.addArrangedSubview(imageView)
        }
        if messageLabel.text != nil {
            stackView.addArrangedSubview(messageLabel)
        }
        if actionButton.titleLabel?.text != nil {
            stackView.addArrangedSubview(actionButton)
        }

        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
    }

    // MARK: Actions

    func actionTapped() {
        emptyState.action?.handler?()
    }

}

public protocol VaporDataSource {

    var numberOfItems: Int { get }
    var emptyState: EmptyState { get }
    var viewForEmptyState: UIView { get }

}

public extension VaporDataSource where Self: UIViewController {

    func show(emptyState: EmptyState) {
        if let existingView = existingEmptyStateView, existingView.emptyState == emptyState {
            return
        }

        show(emptyStateView: EmptyStateView(emptyState: emptyState))
    }

    func show(emptyStateView: EmptyStateView) {
        if let existingView = existingEmptyStateView {
            hide(emptyStateView: existingView)
        }

        emptyStateView.alpha = 0.0

        viewForEmptyState.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.leadingAnchor.constraint(equalTo: viewForEmptyState.leadingAnchor).isActive = true
        emptyStateView.trailingAnchor.constraint(equalTo: viewForEmptyState.trailingAnchor).isActive = true
        emptyStateView.topAnchor.constraint(equalTo: viewForEmptyState.topAnchor).isActive = true
        emptyStateView.bottomAnchor.constraint(equalTo: viewForEmptyState.bottomAnchor).isActive = true

        UIView.animate(withDuration: 0.3) {
            emptyStateView.alpha = 1.0
        }
    }

    func hide(emptyState: EmptyState) {
        if let existingView = existingEmptyStateView, existingView.emptyState == emptyState {
            hide(emptyStateView: existingView)
        }
    }
    
    func hide(emptyStateView: EmptyStateView) {
        guard let existingView = existingEmptyStateView else {
            return
        }

        UIView.animate(withDuration: 0.3, animations: {
            existingView.alpha = 0.0
        }, completion: { (completed) in
            existingView.removeFromSuperview()
        })
    }

    private var existingEmptyStateView: EmptyStateView? {
        for view in view.subviews {
            if let emptyStateView = view as? EmptyStateView {
                return emptyStateView
            }
        }

        return nil
    }
}
