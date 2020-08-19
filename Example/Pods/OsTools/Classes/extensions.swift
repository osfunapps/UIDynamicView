//
//  extensions.swift
//  BuildDynamicUi
//
//  Created by Oz Shabat on 30/12/2018.
//  Copyright © 2018 osApps. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    /// Will init a ui color using hex string: "#ffffff" for white, for example
    public convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(CFloat(r) / 255), green: CGFloat(CFloat(g) / 255), blue: CGFloat(Float(b) / 255), alpha: CGFloat(Float(a) / 255))
    }
}

extension String
{
    
    /// Will capitalize the first letter of a string (not in place)
    public func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    /// Will capitalize the first letter of  string
    public mutating func capitalizeFirstLetterInPlace() {
        self = self.capitalizeFirstLetter()
    }
    
    /// Will replace all of the ocurrences of a string in string with a string
    public func replace(_ target: String, _ withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

extension Array where Element: Equatable {
    
    // Will remove the first collection element that is equal to the given object
    public mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}

extension UIView {
    
    /// Will hide/show a view
    public func hide(_ hide: Bool){
        DispatchQueue.main.async {
            self.isHidden = hide
        }
    }
    
    /// Will run a "blink" animation to a view
    public func blink(duration: TimeInterval = 0.5,
               delay: TimeInterval = 0.0,
               alpha: CGFloat = 0.0,
               repeatCount: Float = 2,
               allowUserInteractionDuringBlink: Bool = true) {

        var options: UIView.AnimationOptions = [.curveEaseInOut, .repeat, .autoreverse]
        if allowUserInteractionDuringBlink {
            options.insert(.allowUserInteraction)
        }
        
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            UIView.setAnimationRepeatCount(repeatCount)
            self.alpha = alpha
        })
    }
    
    
    /// Will do a fade in effect on a view
    public func fadeIn(_ completion: @escaping () -> Void){
        self.alpha = 0.0
        self.hide(false)
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: { _ in
            completion()
        })
    }
    
    /// Will do a fade out effect on a view
    public func fadeOut(_ completion: @escaping () -> Void){
        self.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.hide(true)
            completion()
        })
    }
    
    
    /// Will do a custom fade effect on a view
    public func fade(fromAlpha: CGFloat,
              toAlpha: CGFloat,
              animationOptions: UIView.AnimationOptions,
              duration: TimeInterval = 0.5,
              _ completion: @escaping () -> Void){
        self.alpha = fromAlpha
        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
            self.alpha = toAlpha
        }, completion: { _ in
            completion()
        })
    }
    
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    /// Will run a rotate animation on a view
    public func rotate(duration: Double = 1) {
        
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    /// Will stop a rotating
    /// view animation
    public func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
    
    
    /// Will recursively look for the view with the accessibility Identifier specified
    public func viewWith(_ accessibilityIdentifier: String) -> UIView? {
         if(self.accessibilityIdentifier != nil &&
             self.accessibilityIdentifier == accessibilityIdentifier) {
             return self
         } else if(self.subviews.count > 0) {
             for i in 0..<self.subviews.count {
                 let found = self.subviews[i].viewWith(accessibilityIdentifier)
                 if(found != nil) {
                     return found
                 }
             }
             return nil
         } else {
             return nil
         }
     }
    
    /// Will show a view and set it as clickable or hide it and set it unclickable
    public func toggleShowAndClickable(show: Bool) {
        isUserInteractionEnabled = show
        hide(!show)
    }
    
    /// Will add a shadow to a view
      public func dropShadow(scale: Bool = true, shadowRadius: CGFloat = 2.5, opacity: Float = 1) {
          layer.masksToBounds = false
          layer.shadowColor = UIColor.black.cgColor
          layer.shadowOpacity = opacity
          layer.shadowOffset = .zero
          layer.shadowRadius = shadowRadius
          layer.shouldRasterize = true
          layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
      
      /// Will adjust view leading and trailing according to parent
      public func pinToParentHorizontally(constant: CGFloat = 0) {
          toLeadingOfParent(constant: constant)
          toTrailingOfParent(constant: constant)
      }
      
      /// Will put the view at the start of the parent
      public func toLeadingOfParent(constant: CGFloat = 0) {
          leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: constant).isActive = true
      }
      
      /// Will put the view at the end of the parent
      public func toTrailingOfParent(constant: CGFloat = 0) {
          trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: -constant).isActive = true
      }
      
      /// Will put the view at the x center of the parent
      public func centralizeHorizontalInParent() {
          centerXAnchor.constraint(equalTo: superview!.centerXAnchor).isActive = true
      }
      
      /// Will put the view at the y center of the parent
      public func centralizeVerticalInParent() {
          centerYAnchor.constraint(equalTo: superview!.centerYAnchor).isActive = true
      }
      
      
      /// Will set the width constraint of a view
      public func setWidth(width: CGFloat) {
          widthAnchor.constraint(equalToConstant: width).isActive = true
      }
      
      /// Will set the height constraint of a view
      public func setHeight(height: CGFloat) {
          heightAnchor.constraint(equalToConstant: height).isActive = true
      }
      
      /// Will attach the view to the top of it's parent
      public func pinToParentTop(constant: CGFloat = 0) {
          topAnchor.constraint(equalTo: superview!.topAnchor, constant: constant).isActive = true
      }
      
      /// Will attach the view to the bottom of it's parent
      public func pinToParentBottom(constant: CGFloat = 0) {
          bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: constant).isActive = true
      }
    
    /// Will return the currently focused view
    public var firstResponder: UIView? {
           guard !isFirstResponder else { return self }

           for subview in subviews {
               if let firstResponder = subview.firstResponder {
                   return firstResponder
               }
           }

           return nil
       }
    
      
      /// Will force fresh the layout of the view
      public func refreshLayout() {
          setNeedsLayout()
          layoutIfNeeded()
      }
    
}

/// Will set a title for all of the button's states (normal, selected and disabled)
extension UIButton {
    public func setAllStatesTitle(_ newTitle: String){
        self.setTitle(newTitle, for: .normal)
        self.setTitle(newTitle, for: .selected)
        self.setTitle(newTitle, for: .disabled)
    }
    
}

extension UILabel {
    
    /// Will set the attributed text to a label
    public func setAttributedText(_ newText: String) {
        attributedText = NSAttributedString(string: newText, attributes: attributedText!.attributes(at: 0, effectiveRange: nil))
    }
    
    
    /// Will set a regual and a bold text in the same label string
    public func setRegualAndBoldText(regualText: String,
                                     boldiText: String) {
        
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: font.pointSize)]
        let regularString = NSMutableAttributedString(string: regualText)
        let boldiString = NSMutableAttributedString(string: boldiText, attributes:attrs)
        regularString.append(boldiString)
        attributedText = regularString
    }
    
    /// will set the text in the label if exists else hide the label
    public func setAttribTextOrHide(_ str: String?) {
        if(str == nil || str == ""){
            hide(true)
        } else {
            hide(false)
            setAttributedText(str!)
        }
      }
}

extension String {
    
    /// Will replace the last occurrence of a char in a string
    public func replaceLastOccurrenceOfString(_ searchString: String,
                                       with replacementString: String,
                                       caseInsensitive: Bool = true) -> String
    {
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        } else {
            options = [.backwards]
        }
        
        if let range = self.range(of: searchString,
                                  options: options,
                                  range: nil,
                                  locale: nil) {
            
            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
    
    // substring. To use:
    // let myStr = "lola"
    // let halfHint: String = myStr[0...myStr.count-2]
    /// substring functions
    public subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    public subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    public subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
}

extension UINavigationController {
    
    /// Will check if a view controller is exists in the navigation controller's stack
    public func hasViewController(ofKind kind: AnyClass) -> Bool {
        return self.viewControllers.first(where: {$0.isKind(of: kind)}) != nil
    }
    
    /// Will make the navigation bar translucent
    public func makeTransperent() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    /// Will set the navigation bar backgrond color
    public func backgroundColor(uiColor: UIColor) {
        navigationBar.barTintColor = uiColor
        navigationBar.isTranslucent = false
    }
    
    
}

/// Will cpaitalize each word in an array of strings
extension Array where Element == String {
    public func capitalize() -> [String] {
        var newArr = [String]()
        forEach { it in
            newArr.append(it.capitalized)
        }
        return newArr
    }
}


extension Array where Element == UInt8  {
    
    /// Will return the string representation of an array
    public func toString() -> String {
        return description
    }
    
    /// Will slice an array from a starting point to an end point
    public func slice(_ from: Int, _ to: Int? = nil) -> [UInt8] {
        var start = from
        var end = count - 1
        
        if from < 0 {
            if (to == nil) {
                let toStart = count + from
                if(toStart <= 0) {
                    start = 0
                } else {
                    start = count + from
                }
                end = count - 1
            }
        } else {
            if let _to = to {
                start = from
                if _to <= 0 {
                    end = count - 1 + _to
                } else {
                    end = _to - 1
                }
            }
        }
        if start == count {
            if(end == count - 1) {
                return [UInt8]()
            }
            start = count - 1
        }
        if end < start {
            end = count - 1
        }
        return Array(self[start...end])
    }
    
    /// Will parse an array to an UTF string
    public func toUTFString() -> String? {
        if let string = String( bytes: self, encoding: .utf8) {
            return string
        } else {
            print("not a valid UTF-8 sequence")
            return ""
        }
    }
    
    /// Will parse an array to Hex string
    var toHexaString: String {
        return map{ String(format: "%02X", $0) }.joined()
    }
    
}


extension StringProtocol {
    public var hexa: [UInt8] {
        var startIndex = self.startIndex
        return stride(from: 0, to: count, by: 2).compactMap { _ in
            let endIndex = index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}

extension UUID {
    
    /// Will return a UUID of an array
    public func asUInt8Array() -> [UInt8]{
        let (u1,u2,u3,u4,u5,u6,u7,u8,u9,u10,u11,u12,u13,u14,u15,u16) = self.uuid
        return [u1,u2,u3,u4,u5,u6,u7,u8,u9,u10,u11,u12,u13,u14,u15,u16]
    }
}


extension KeyValuePairs where Key == String {
    
    /// Will return a specfic element by key
    public func getElement(key: String) -> (String, Value)? {
        return first(where: {$0.key == key })
    }
    
    
    public subscript(key: String) -> Value? {
        get {
            return first(where: {$0.key == key })?.value
        }
    }
}

extension KeyValuePairs where Key == Int {
    
    public subscript(key: Int) -> Value? {
        get {
            return first(where: {$0.key == key })?.value
        }
    }
}

extension CountableClosedRange where Bound == Int {
    
    /// Will return a random value between a close range of numbers. To use: (0...500).randomValue
    public var randomValue: Int {
        return lowerBound + Int(arc4random_uniform(UInt32(upperBound - lowerBound)))
    }
}

extension UITextField {
    
    /// Will add a done button to a text field. When clicked, it will resign the first responder. Notice: If you want to add a done button to multiple fields, don't use this function
    public func addDoneButton(title: String = "Done", style: UIBarStyle = .default) {
        
        let applyToolbar = UIToolbar()
        applyToolbar.barStyle = style
        
        applyToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: title, style: .done, target: self, action: #selector(resignFirstResponder))
        ]
        
        applyToolbar.sizeToFit()
        inputAccessoryView = applyToolbar
    }
}
