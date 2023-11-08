//
//  BaseSnackBarView.swift
//
//
//  Created by Evgeniy Antonov on 08.11.2023.
//

import UIKit

class BaseSnackBarView {
    private enum Constants {
        enum Duration {
            static let animation: CGFloat = 0.25
            static let visibility: TimeInterval = 3
            static let updation: CGFloat = 0.25
        }
        
        enum Padding {
            static let horizontal: CGFloat = 16
            static let vertical: CGFloat = 10
        }
    }
    
    lazy var window: UIWindow? = {
        UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .last
    }()
    
    private var labelHeight: CGFloat {
        guard let window, let snackLabelLocally else { return 0 }
        let width = window.frame.size.width - 2 * Constants.Padding.horizontal
        
        return snackLabelLocally.systemLayoutSizeFitting(
            CGSize(
                width: width,
                height: UIView.layoutFittingCompressedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
    }
    
    private var snackViewLocally: UIView?
    private var snackLabelLocally: UILabel?
    var initialStickyConstraintValue: CGFloat = 0
    private var heightConstraint: NSLayoutConstraint?
    var stickyConstraint: NSLayoutConstraint?
    private var timer: Timer?
    private var inProgress = false
    
    var yPadding: CGFloat {
        fatalError("`yPadding` variable should be overrided")
    }
    
    public func show(
        _ message: String,
        duration: TimeInterval,
        backgroundColor: UIColor,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont,
        maxNumberOfLines: Int
    ) {
        if inProgress {
            updateView(
                message,
                duration: duration,
                backgroundColor: backgroundColor,
                textColor: textColor,
                textAlignment: textAlignment,
                font: font,
                maxNumberOfLines: maxNumberOfLines
            )
        } else {
            startView(
                message,
                duration: duration,
                backgroundColor: backgroundColor,
                textColor: textColor,
                textAlignment: textAlignment,
                font: font,
                maxNumberOfLines: maxNumberOfLines
            )
        }
    }
    
    private func startView(
        _ message: String,
        duration: TimeInterval,
        backgroundColor: UIColor,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont,
        maxNumberOfLines: Int
    ) {
        guard let window else { return }
        inProgress = true
        
        let snackView = UIView()
        snackView.translatesAutoresizingMaskIntoConstraints = false
        snackView.backgroundColor = backgroundColor
        snackView.clipsToBounds = true
        window.addSubview(snackView)
        snackViewLocally = snackView
        
        let snackLabel = UILabel()
        snackLabel.translatesAutoresizingMaskIntoConstraints = false
        snackLabel.font = font
        snackLabel.textColor = textColor
        snackLabel.numberOfLines = maxNumberOfLines
        snackLabel.text = message
        snackLabel.textAlignment = textAlignment
        snackView.addSubview(snackLabel)
        snackLabelLocally = snackLabel
        
        calculateHeight()
        setupStickyHeader(snackView)
        
        heightConstraint = snackView.heightAnchor.constraint(equalToConstant: initialStickyConstraintValue)
        guard let heightConstraint, let stickyConstraint else { return }
        
        NSLayoutConstraint.activate(
            [
                stickyConstraint,
                snackView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                snackView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                heightConstraint,
                
                yLabelConstraint(
                    snackView: snackView,
                    snackLabel: snackLabel,
                    constant: Constants.Padding.vertical),
                snackLabel.leadingAnchor.constraint(
                    equalTo: snackView.leadingAnchor,
                    constant: Constants.Padding.horizontal
                ),
                snackView.trailingAnchor.constraint(
                    equalTo: snackLabel.trailingAnchor,
                    constant: Constants.Padding.horizontal
                )
            ]
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            stickyConstraint.constant = 0
            UIView.animate(
                withDuration: Constants.Duration.animation,
                animations: {
                    window.layoutSubviews()
                },
                completion: { _ in
                    self.startTimer(duration)
                }
            )
        }
    }
    
    private func updateView(
        _ message: String,
        duration: TimeInterval,
        backgroundColor: UIColor,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont,
        maxNumberOfLines: Int
    ) {
        guard let snackViewLocally, let snackLabelLocally else { return }
        
        snackLabelLocally.numberOfLines = maxNumberOfLines
        
        UIView.animate(
            withDuration: Constants.Duration.updation,
            animations: {
                snackViewLocally.backgroundColor = backgroundColor
                snackLabelLocally.textColor = textColor
            }
        )
        
        UIView.transition(
            with: snackLabelLocally,
            duration: Constants.Duration.updation,
            options: .transitionCrossDissolve,
            animations: {
                snackLabelLocally.text = message
                snackLabelLocally.font = font
                snackLabelLocally.textAlignment = textAlignment
            }
        )
        
        calculateHeight()
        
        heightConstraint?.constant = initialStickyConstraintValue
        UIView.animate(withDuration: Constants.Duration.updation) {
            self.window?.layoutSubviews()
        }
        
        startTimer(duration)
    }
    
    private func calculateHeight() {
        initialStickyConstraintValue = yPadding + labelHeight + Constants.Padding.vertical
    }
    
    func setupStickyHeader(_ snackView: UIView) {
        fatalError("`setupStickyHeader(_ snackView: UIView)` method should be overrided")
    }
    
    func yLabelConstraint(snackView: UIView, snackLabel: UILabel, constant: CGFloat) -> NSLayoutConstraint {
        fatalError("`yLabelConstraint(_ snackView: UIView, snackLabel: UILabel)` method should be overrided")
    }
    
    private func startTimer(_ interval: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: false,
            block: { [weak self] _ in
                self?.hide()
            }
        )
    }
    
    private func hide() {
        guard let window, let stickyConstraint else { return }
        stickyConstraint.constant = -initialStickyConstraintValue
        
        UIView.animate(
            withDuration: Constants.Duration.animation,
            animations: {
                window.layoutSubviews()
            }, completion: { _ in
                self.snackViewLocally?.removeFromSuperview()
                self.clear()
                self.inProgress = false
            }
        )
    }
    
    private func clear() {
        snackViewLocally = nil
        snackLabelLocally = nil
        heightConstraint = nil
        timer = nil
    }
}
