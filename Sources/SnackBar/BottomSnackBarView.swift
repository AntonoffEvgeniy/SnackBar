//
//  BottomSnackBarView.swift
//
//
//  Created by Evgeniy Antonov on 08.11.2023.
//

import UIKit

final class BottomSnackBarView: BaseSnackBarView {
    static let shared = BottomSnackBarView()
    
    private lazy var bottomPadding: CGFloat = {
        window?.safeAreaInsets.bottom ?? 0
    }()
    
    // MARK: - Override
    
    override var yPadding: CGFloat { bottomPadding }
    
    override func setupStickyHeader(_ snackView: UIView) {
        guard let window else { return }
        stickyConstraint = window.bottomAnchor.constraint(
            equalTo: snackView.bottomAnchor,
            constant: -initialStickyConstraintValue
        )
    }
    
    override func yLabelConstraint(
        snackView: UIView,
        snackLabel: UILabel,
        constant: CGFloat
    ) -> NSLayoutConstraint {
        snackLabel.topAnchor.constraint(
            equalTo: snackView.topAnchor,
            constant: constant
        )
    }
}
