//
//  UIDialogWrapper.swift
//  OsUIInteraction_Example
//
//  Created by Oz Shabat on 18/08/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper

public class UIDialogWrapper {
    
    // views
    private var dynamicContainer: UIDynamicView? = nil
    
    // constants
    private let TAG_TITLE_VIEW = 90
    private let TAG_TOP_DESCRIPTION_VIEW = 91
    private let TAG_BOTTOM_DESCRIPTION_VIEW = 92
    private let TAG_INPUT_VIEW = 93
    private let TAG_IMAGE_VIEW = 94
    private let TAG_YOUTUBE_VIEW = 95
    private let TAG_LEFT_BUTTON_VIEW = 96
    private let TAG_RIGHT_BUTTON_VIEW = 97
    private let TAG_BUTTONS_STACK_VIEW = 98
    
    public init(parentView: UIView,
                padding: CGFloat = UIDynamicView.DEF_PADDING,
                margin: CGFloat = UIDynamicView.DEF_MARGIN,
                maxWidthPercentFromParent: CGFloat = 1.0) {
        dynamicContainer = UIDynamicView()
        dynamicContainer!.prepareView(parentView: parentView, padding: padding, margin: margin, maxWidthPercentFromParent: maxWidthPercentFromParent)
        dynamicContainer!.dropShadow()
    }
    
    
    public func setTitle(text: String, fontName: String? = nil, size: CGFloat = 27) {
        var font = UIFont.systemFont(ofSize: size, weight: .bold)
        if let _fontName = fontName {
            font = UIFont(name: _fontName, size: size)!
        }
        let initialProps = InitialLabelProps(text: text, textAlignment: .center, numberOfLines: 1, tag: TAG_TITLE_VIEW, font: font, lineHeightMultiply: 1)
        dynamicContainer!.addView(initialProps: initialProps)
    }
    
    public func setTopDesription(text: String, fontName: String? = nil, size: CGFloat = 16) {
        setDescription(text: text, fontName: fontName, size: size, tag: TAG_TOP_DESCRIPTION_VIEW)
    }
    
    public func setBottomDesription(text: String, fontName: String? = nil, size: CGFloat = 16) {
        setDescription(text: text, fontName: fontName, size: size, tag: TAG_BOTTOM_DESCRIPTION_VIEW)
    }
    
    private func setDescription(text: String, fontName: String? = nil, size: CGFloat, tag: Int) {
        var font = UIFont.systemFont(ofSize: size)
        if let _fontName = fontName {
            font = UIFont(name: _fontName, size: size)!
        }
        let initialProps = InitialLabelProps(text: text,
                                             textAlignment: .left,
                                             numberOfLines: 0,
                                             tag: tag,
                                             font: font,
                                             lineHeightMultiply: 1.5)
        dynamicContainer!.addView(initialProps: initialProps)
    }
    
    
    public func setImageView(imageName: String, widthPercentFromParent: CGFloat = 1.0) {
        let initialProps = InitialUIImageViewProps(imageName: imageName,
                                                   widthPercentFromParent: widthPercentFromParent,
                                                   tag: TAG_IMAGE_VIEW,
                                                   alignment: .center)
        dynamicContainer!.addView(initialProps: initialProps)
    }
    
    public func setYoutubeVideo(videoId: String, widthPercentFromParent: CGFloat = 1.0, heightPercentFromWidth: CGFloat = 0.5) {
        let initialProps = InitialYoutubeVideoProps(videoId: videoId,
                                                    widthPercentFromParent: widthPercentFromParent,
                                                    heightPercentFromWidth: heightPercentFromWidth,
                                                    tag: TAG_YOUTUBE_VIEW,
                                                    alignment: .center)
        dynamicContainer!.addView(initialProps: initialProps)
    }
    
    public func setFooter(leftBtnText: String? = nil,
                          rightBtnText: String? = nil,
                          leftBtnTapSelector: Selector? = nil,
                          rightBtnTapSelector: Selector? = nil) {
        
        var initialBtnsPropList = [InitialButtonProps]()
        if let _leftBtnText = leftBtnText, let _leftBtnTapSelector = leftBtnTapSelector {
            let leftBtnProps = InitialButtonProps(labelText: _leftBtnText,
                                                  alignment: .left,
                                                  tapSelector: _leftBtnTapSelector,
                                                  tag: TAG_LEFT_BUTTON_VIEW)
            initialBtnsPropList.append(leftBtnProps)
        }
        
        if let _rightBtnText = rightBtnText, let _rightBtnTapSelector = rightBtnTapSelector {
            let rightBtnProps = InitialButtonProps(labelText: _rightBtnText,
                                                   alignment: .right,
                                                   tapSelector: _rightBtnTapSelector,
                                                   tag: TAG_RIGHT_BUTTON_VIEW)
            initialBtnsPropList.append(rightBtnProps)
        }
        
        
        if !initialBtnsPropList.isEmpty {
            let svInitialProps = InitialStackViewProps(subviewsInitialPropsList: initialBtnsPropList, tag: TAG_BUTTONS_STACK_VIEW)
            dynamicContainer!.addView(initialProps: svInitialProps)
        }
        
    }
    
    public func setInputField(placeHolder: String,
                              approximateCharCount: Int,
                              keyboardType: UIKeyboardType = .default,
                              fontName: String? = nil,
                              size: CGFloat = 18) {
        var font = UIFont.systemFont(ofSize: size)
        if let _fontName = fontName {
            font = UIFont(name: _fontName, size: size)!
        }
        
        let initialProps = InitialUITextFieldProps(approximateCharCount: approximateCharCount,
                                                   placeHolder: placeHolder,
                                                   alignment: .center,
                                                   keyboardType: keyboardType,
                                                   tag: TAG_INPUT_VIEW,
                                                   font: font)
        dynamicContainer!.addView(initialProps: initialProps)
    }
    
    public func attachView(parentView: UIView, preventInteractionWithOtherViews: Bool = true) {
        dynamicContainer!.attachView(parentView: parentView, preventInteractionWithOtherViews: preventInteractionWithOtherViews)
    }
    
    // TODO: control the fade out duration
    public func dismiss() {
        dynamicContainer?.fadeOut {
            self.dynamicContainer?.removeFromSuperview()
            self.dynamicContainer = nil
        }
    }
    
    
    // MARK: - getters
    public func getTitleLabel() -> UILabel? {
        return dynamicContainer!.viewWithTag(TAG_TITLE_VIEW) as? UILabel
    }
    
    public func getTopDescriptionLabel() -> UILabel? {
        return dynamicContainer!.viewWithTag(TAG_TOP_DESCRIPTION_VIEW) as? UILabel
    }
    
    public func getBottomDescriptionLabel() -> UILabel? {
        return dynamicContainer!.viewWithTag(TAG_BOTTOM_DESCRIPTION_VIEW) as? UILabel
    }
    
    public func getInputTextField() -> UITextField? {
        return dynamicContainer!.viewWithTag(TAG_INPUT_VIEW) as? UITextField
    }
    
    public func getImageView() -> UIImageView? {
        return dynamicContainer!.viewWithTag(TAG_IMAGE_VIEW) as? UIImageView
    }
    
    public func getLeftButton() -> UIButton? {
        return dynamicContainer!.viewWithTag(TAG_LEFT_BUTTON_VIEW) as? UIButton
    }
    
    public func getRightButton() -> UIButton? {
        return dynamicContainer!.viewWithTag(TAG_RIGHT_BUTTON_VIEW) as? UIButton
    }
    
    public func getYoutubeView() -> YTPlayerView? {
        return dynamicContainer!.viewWithTag(TAG_YOUTUBE_VIEW) as? YTPlayerView
    }
        
}
