//
//  TopSnackBarView.swift
//
//
//  Created by Evgeniy Antonov on 08.11.2023.
//

import UIKit

final class TopSnackBarView: BaseSnackBarView {
    static let shared = TopSnackBarView()
    
    private lazy var topPadding: CGFloat = {
        window?.safeAreaInsets.top ?? 0
    }()
    
    // MARK: - Override
    
    override var yPadding: CGFloat { topPadding }
    
    override func setupStickyHeader(_ snackView: UIView) {
        guard let window else { return }
        stickyConstraint = snackView.topAnchor.constraint(
            equalTo: window.topAnchor,
            constant: -initialStickyConstraintValue
        )
    }
    
    override func yLabelConstraint(
        snackView: UIView,
        snackLabel: UILabel,
        constant: CGFloat
    ) -> NSLayoutConstraint {
        snackView.bottomAnchor.constraint(
            equalTo: snackLabel.bottomAnchor,
            constant: constant
        )
    }
}
