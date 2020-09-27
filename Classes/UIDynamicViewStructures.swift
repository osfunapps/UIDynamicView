//
//  UIDynamicViewStructures.swift
//  OsUIInteraction_Example
//
//  Created by Oz Shabat on 18/08/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/// Will create a struct containing the initial props for a UILabel
public struct InitialLabelProps: InitialProps {
    
    var text: String
    var textAlignment: UIViewAlignment
    var numberOfLines: Int
    var tag: Int
    var font: UIFont
    var lineHeightMultiply: CGFloat
    
    public init(text: String,
                textAlignment: UIViewAlignment = .center,
                numberOfLines: Int = 0,
                tag: Int = 0,
                font: UIFont = UIFont.systemFont(ofSize: 17),
                lineHeightMultiply: CGFloat = 1.25) {
        self.text = text
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.tag = tag
        self.font = font
        self.lineHeightMultiply = lineHeightMultiply
    }
    public func getType() -> UIViewType {
        return .label
    }
}

/// Will create a struct containing the initial props for a UITextView
public struct InitialUITextViewProps: InitialProps {
    
    var text: String
    var textAlignment: UIViewAlignment
    var tag: Int
    var font: UIFont
    var lineHeightMultiply: CGFloat
    var isEditable: Bool
    
    public init(text: String,
                textAlignment: UIViewAlignment = .center,
                tag: Int = 0,
                font: UIFont = UIFont.systemFont(ofSize: 17),
                lineHeightMultiply: CGFloat = 1.25,
                isEditable: Bool = false) {
        self.text = text
        self.textAlignment = textAlignment
        self.tag = tag
        self.font = font
        self.lineHeightMultiply = lineHeightMultiply
        self.isEditable = isEditable
    }
    public func getType() -> UIViewType {
        return .textView
    }
}


/// Will create a struct containing the initial props for a UITextField
public struct InitialUITextFieldProps: InitialProps {
    
    var approximateCharCount: Int
    var placeHolder: String
    var backgroundColor: UIColor
    var textColor: UIColor
    var alignment: UIViewAlignment
    var keyboardType: UIKeyboardType
    var tag: Int
    var font: UIFont
    
    public init(approximateCharCount: Int,
                placeHolder: String,
                backgroundColor: UIColor = .white,
                textColor: UIColor = .black,
                alignment: UIViewAlignment = .center,
                keyboardType: UIKeyboardType = .default,
                tag: Int = 0,
                font: UIFont = UIFont.systemFont(ofSize: 17)) {
        self.approximateCharCount = approximateCharCount
        self.placeHolder = placeHolder
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.alignment = alignment
        self.keyboardType = keyboardType
        self.tag = tag
        self.font = font
    }
    
    public func getType() -> UIViewType {
        return .textField
    }
}



/// Will create a struct containing the initial props for a UIImageView
public struct InitialUIImageViewProps: InitialProps {
    var imageName: String
    var widthPercentFromParent: CGFloat
    var tag: Int
    var alignment: UIViewAlignment
    
    public init(imageName: String,
                widthPercentFromParent: CGFloat = 1.0,
                tag: Int = 0,
                alignment: UIViewAlignment = .center) {
        self.imageName = imageName
        self.widthPercentFromParent = widthPercentFromParent
        self.tag = tag
        self.alignment = alignment
    }
    
    public func getType() -> UIViewType {
        return .imageView
    }
}

/// Will create a struct containing the initial props for a YoutubeVideo
public struct InitialYoutubeVideoProps: InitialProps {
    
    var videoId: String
    var widthPercentFromParent: CGFloat
    var heightPercentFromWidth: CGFloat
    var tag: Int
    var alignment: UIViewAlignment
    
    public init(videoId: String,
                widthPercentFromParent: CGFloat = 1.0,
                heightPercentFromWidth: CGFloat = 1.0,
                tag: Int = 0,
                alignment: UIViewAlignment = .center) {
        self.videoId = videoId
        self.widthPercentFromParent = widthPercentFromParent
        self.heightPercentFromWidth = heightPercentFromWidth
        self.tag = tag
        self.alignment = alignment
    }
    
    public func getType() -> UIViewType {
        return .youtubeVideo
    }
}

/// Will create a struct containing the initial props for a UIButton
public struct InitialButtonProps: InitialProps {
    
    var labelText: String
    var alignment: UIViewAlignment
    var tapSelector: Selector
    var tapTarget: Any?
    var font: UIFont
    var tag: Int
    
    public init(labelText: String,
                alignment: UIViewAlignment = .center,
                tapSelector: Selector,
                tapTarget: Any? = nil,
                font: UIFont = UIFont.systemFont(ofSize: 15),
                tag: Int = 0) {
        self.labelText = labelText
        self.alignment = alignment
        self.tapSelector = tapSelector
        self.tapTarget = tapTarget
        self.tag = tag
        self.font = font
    }
    
    public func getType() -> UIViewType {
        return .button
    }
}

/// Will create a struct containing the initial props for a UIStackView
public struct InitialStackViewProps: InitialProps {
    
    /// Will hold a list of all of the initial properties for the stack view's subviews. For example: [InitialButtonProps.init(), InitialLabelProps.init(), etc...]
    var subviewsInitialPropsList: [InitialProps]
    
    var spacing: CGFloat
    var axis: NSLayoutConstraint.Axis
    var distribution: UIStackView.Distribution
    var tag: Int
    
    public init(subviewsInitialPropsList: [InitialProps],
                spacing: CGFloat = 10,
                axis: NSLayoutConstraint.Axis = .horizontal,
                distribution: UIStackView.Distribution = .equalSpacing,
                tag: Int = 0) {
           self.subviewsInitialPropsList = subviewsInitialPropsList
           self.spacing = spacing
           self.axis = axis
           self.distribution = distribution
           self.tag = tag
       }
       
    
    public func getType() -> UIViewType {
        return .stackView
    }
}


public protocol InitialProps {
    func getType() -> UIViewType
}

public enum UIViewType {
    case label
    case textField
    case imageView
    case youtubeVideo
    case button
    case stackView
    case textView
}

public enum UIViewAlignment {
    case left
    case center
    case right
}

