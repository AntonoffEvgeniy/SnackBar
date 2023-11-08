//
//  BaseSnackBarView.swift
//
//
//  Created by Evgeniy Antonov on 08.11.2023.
//

import UIKit

public final class SnackBar {
    public class var settings: Settings { Settings.shared }
    
    public static func show(
        _ message: String,
        position: Position,
        duration: TimeInterval? = nil,
        backgroundColor: UIColor? = nil,
        textColor: UIColor? = nil,
        textAlignment: NSTextAlignment? = nil,
        font: UIFont? = nil,
        maxNumberOfLines: Int? = nil
    ) {
        let value = duration ?? settings.interval
        let interval = max(Constants.Duration.animation, value)
        
        switch position {
        case .top:
            executeTop(
                message,
                duration: interval,
                backgroundColor: backgroundColor ?? settings.backgroundColor,
                textColor: textColor ?? settings.textColor,
                textAlignment: textAlignment ?? settings.textAlignment,
                font: font ?? settings.font,
                maxNumberOfLines: maxNumberOfLines ?? settings.maxNumberOfLines
            )
        case .bottom:
            executeBottom(
                message,
                duration: interval,
                backgroundColor: backgroundColor ?? settings.backgroundColor,
                textColor: textColor ?? settings.textColor,
                textAlignment: textAlignment ?? settings.textAlignment,
                font: font ?? settings.font,
                maxNumberOfLines: maxNumberOfLines ?? settings.maxNumberOfLines
            )
        }
    }
    
    private static func executeTop(
        _ message: String,
        duration: TimeInterval,
        backgroundColor: UIColor,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont,
        maxNumberOfLines: Int
    ) {
        TopSnackBarView.shared.show(
            message,
            duration: duration,
            backgroundColor: backgroundColor,
            textColor: textColor,
            textAlignment: textAlignment,
            font: font,
            maxNumberOfLines: maxNumberOfLines
        )
    }
    
    private static func executeBottom(
        _ message: String,
        duration: TimeInterval,
        backgroundColor: UIColor,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        font: UIFont,
        maxNumberOfLines: Int
    ) {
        BottomSnackBarView.shared.show(
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

public extension SnackBar {
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
        
        static let maxNumberOfLines = 3
    }
    
    enum Position {
        case top, bottom
    }
    
    final class Settings {
        static let shared = Settings()
        
        private init() {}
        
        public var interval = Constants.Duration.visibility
        public var maxNumberOfLines = Constants.maxNumberOfLines
        public var backgroundColor: UIColor = .red
        public var font: UIFont = .systemFont(ofSize: 12)
        public var textColor: UIColor = .black
        public var textAlignment: NSTextAlignment = .left
    }
}
