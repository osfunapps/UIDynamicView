//
//  SelfSignedView.swift
//  OsUIInteraction_Example
//
//  Created by Oz Shabat on 12/08/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import OsTools

/// Represents a dynamic view to be structured from code
public class UIDynamicView: UIView {
    
    /// The view which holds all of the added views
    @IBOutlet public weak var viewsContainer: UIView!
    @IBOutlet public weak var scrollView: UIScrollView!
    @IBOutlet private var contentView: UIView!
    
    /// The scroll view holder
    @IBOutlet public weak var parentView: UIView!
    @IBOutlet weak var containerViewTopConstr: NSLayoutConstraint!
    
    // indications
    public var padding: CGFloat!
    public var margin: CGFloat!
    public var spaceBetweenViews = DEF_SPACE_BETWEEN_VIEWS
    private var maxInnerSize: CGFloat = 0
    private var latestViewAdded: UIView? = nil
    private var containerViewTopConstrConst: CGFloat!
    private var siblingViewsInteractable = true
    private var preventClicksOnOtherViews = false
    
    private var currViewsContainerWidth: CGFloat = 0
    private var currViewsContainerHeight: CGFloat = 0
    private var viewsContainerWidthConstr: NSLayoutConstraint = NSLayoutConstraint()
    private var viewsContainerHeightConstr: NSLayoutConstraint = NSLayoutConstraint()
    private var maxViewsContainerWidth: CGFloat!
    
    // constants
    public static let DEF_PADDING: CGFloat = 14
    public static let DEF_MARGIN: CGFloat = 14
    private static let DEF_SPACE_BETWEEN_VIEWS: CGFloat = 10
    private let DEF_USER_TF_CHAR_COUNT: Int = 30
    private let CONSTRAINT_WIDTH_ID = "width"
    
    
    /// Will prepare the view for first init. Call this method on startup
    ///
    /// - Parameter parentView: The parent view to attach to
    /// - Parameter padding: The spacing between the frame to the inner views
    /// - Parameter margin: The spacing between the view to it's parent
    /// - Parameter maxWidthPercentFromParent: The maximum width of the view, related to it's parent view
    public func prepareView(parentView: UIView,
                            padding: CGFloat = DEF_PADDING,
                            margin: CGFloat = DEF_MARGIN,
                            maxWidthPercentFromParent: CGFloat = 1.0) {
        self.padding = padding
        self.margin = margin
        parentView.refreshLayout()
        maxViewsContainerWidth = (parentView.frame.width) * maxWidthPercentFromParent - margin * 2
        maxInnerSize = maxViewsContainerWidth - padding * 2
        currViewsContainerHeight = padding
    }
    
    
    /// init option 1
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /// init option 2
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// shared init to set contraints
    private func commonInit(){
        //        let bundle = Bundle(for: UIInteractionView.self)
//        Bundle.main.loadNibNamed("UIDynamicView", owner: self, options: nil);
        
        let bundle = Bundle(for: UIDynamicView.self)
        bundle.loadNibNamed("UIDynamicView", owner: self, options: nil)
        
        setFrame()
    }
    
    /// Will prepare the frame for first init
    private func setFrame() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tag = UIDynamicView.VIEW_TAG
    }
    
    /// Will initiate the process of adding a view to the views container
    private func beginViewAddProcedure(_ viewToAdd: UIView, _ horizontalAlignments: [UIViewAlignment]) {
        viewsContainer.addSubview(viewToAdd)
        viewToAdd.refreshLayout()
        let horizontalLocationSet = setViewsContainerSize(viewToAdd, horizontalAlignments)
        if !horizontalLocationSet {
            setHorizontalLocation(viewToAdd, horizontalAlignments)
        }
        setVerticalLocation(viewToAdd)
    }
    
    
    /// Will adjust the horizontal location of the added view
    private func setHorizontalLocation(_ view: UIView, _ alignments: [UIViewAlignment]) {
        alignments.forEach { it in
            switch it {
            case .center:
                view.centralizeHorizontalInParent()
            case .left:
                view.toLeadingOfParent(constant: padding)
            case .right:
                view.toTrailingOfParent(constant: padding)
            }
        }
    }
    
    private func setEqualWidthToParent(_ view: UIView) {
        // will remove any existing width constraint added
        view.constraints.forEach { it in
            if it.identifier == CONSTRAINT_WIDTH_ID {
                it.isActive = false
            }
        }
        
        view.pinToParentHorizontally(constant: padding)
        view.refreshLayout()
    }
    
    /// Will set the container size according to the margin, padding width and height of the inner views
    private func setViewsContainerSize(_ view: UIView, _ horizontalAlignments: [UIViewAlignment]) -> Bool {
        var horizontalLocationSet = false
        
        // if, for some reason, the width of the view will be equal to the maximum width of the parent,
        // we will set the width of the view to be equal to the parent max and set the height accordingly
        if view.frame.width + (padding * 2) >= maxViewsContainerWidth {
            if currViewsContainerWidth != maxViewsContainerWidth {
                viewsContainerWidthConstr.isActive = false
                currViewsContainerWidth = maxViewsContainerWidth
                viewsContainerWidthConstr = viewsContainer.widthAnchor.constraint(equalToConstant: currViewsContainerWidth)
                viewsContainerWidthConstr.isActive = true
            }
            horizontalLocationSet = true
            setEqualWidthToParent(view)
        } else if view.frame.width > currViewsContainerWidth {
            viewsContainerWidthConstr.isActive = false
            currViewsContainerWidth = view.frame.width
            viewsContainerWidthConstr = viewsContainer.widthAnchor.constraint(equalToConstant: currViewsContainerWidth + padding * 2)
            viewsContainerWidthConstr.isActive = true
        }
        viewsContainerHeightConstr.isActive = false
        
        var heightToAppend = view.frame.height
        if let tv = view as? UITextView {
            heightToAppend = setAndGetUITextViewHeight(tv)
        }
        
        currViewsContainerHeight += heightToAppend + spaceBetweenViews
        viewsContainerHeightConstr = viewsContainer.heightAnchor.constraint(equalToConstant: currViewsContainerHeight)
        viewsContainerHeightConstr.isActive = true
        return horizontalLocationSet
    }
    
    /// Will return and set the uitextview height by it's width and content
    private func setAndGetUITextViewHeight(_ tv: UITextView) -> CGFloat {
        let sizeToFitIn = CGSize(width: tv.frame.width, height: CGFloat(MAXFLOAT))
        let newSize = tv.sizeThatFits(sizeToFitIn)
        tv.heightAnchor.constraint(equalToConstant: newSize.height).isActive = true
        return newSize.height
    }
    
    /// Will append a UILabel
    ///
    /// - Parameter initialProps: The UILabel initial props
    /// - Parameter invalidate: Set to true if you want to add the view to the parent
    @discardableResult
    public func addView(initialProps: InitialLabelProps, invalidate: Bool = true) -> UILabel {
        let label = UILabel()
        label.tag = initialProps.tag
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = initialProps.lineHeightMultiply
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        label.attributedText = NSAttributedString(string: initialProps.text, attributes: attributes)
        
        label.numberOfLines = initialProps.numberOfLines
        label.font = initialProps.font
        label.sizeToFit()
        if invalidate {
            beginViewAddProcedure(label, [initialProps.textAlignment])
        }
        return label
    }
    
    /// Will append a UITextView
    ///
    /// - Parameter initialProps: The UITextView initial props
    /// - Parameter invalidate: Set to true if you want to add the view to the parent
    @discardableResult
    public func addView(initialProps: InitialUITextViewProps, invalidate: Bool = true) -> UITextView {
        let view = UITextView()
        view.tag = initialProps.tag
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // line spacing
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = initialProps.lineHeightMultiply
//        var attributes = [NSAttributedString.Key: Any]()
//        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
//        view.attributedText = NSAttributedString(string: initialProps.text, attributes: attributes)
        view.text = initialProps.text
        view.textColor = UIColor.black
        view.isEditable = initialProps.isEditable
        view.font = initialProps.font
        view.sizeToFit()
        if invalidate {
            beginViewAddProcedure(view, [initialProps.textAlignment])
        }
        return view
    }
    
    
    /// Will append a UIButton
    ///
    /// - Parameter initialProps: The UIButton initial props
    /// - Parameter invalidate: Set to true if you want to add the view to the parent
    @discardableResult
    public func addView(initialProps: InitialButtonProps,
                         invalidate: Bool = true) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = initialProps.tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAllStatesTitle(initialProps.labelText)
        button.addTarget(initialProps.tapTarget, action: initialProps.tapSelector, for: .touchUpInside)
        button.titleLabel!.font = initialProps.font
        button.titleLabel!.sizeToFit()
        button.sizeToFit()
        if invalidate {
            beginViewAddProcedure(button, [initialProps.alignment])
        }
        return button
    }
    
        
    /// Will append a UITextField
    ///
    /// - Parameter initialProps: The UITextField initial props
    /// - Parameter invalidate: Set to true if you want to add the view to the parent
    @discardableResult
    public func addView(initialProps: InitialUITextFieldProps, invalidate: Bool = true) -> UITextField {
        let tf = UITextField()
        tf.tag = initialProps.tag
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = initialProps.font
        tf.text = String(repeating: "-", count: initialProps.approximateCharCount)
        tf.placeholder = initialProps.placeHolder
        tf.contentVerticalAlignment = .center
        tf.textAlignment = .center
        tf.borderStyle = .roundedRect
        tf.addDoneButton()
        tf.keyboardType = initialProps.keyboardType
        tf.sizeToFit()
        tf.backgroundColor = initialProps.backgroundColor
        tf.textColor = initialProps.textColor
        tf.setWidth(width: tf.frame.width)
        tf.setHeight(height: tf.frame.height)
        //        tf.textAlignment = textAlignment
        if invalidate {
            beginViewAddProcedure(tf, [initialProps.alignment])
        }
        tf.text = ""
        return tf
    }
    
    /// Will append a UIImageView
    ///
    /// - Parameter initialProps: The UIImageView initial props
    /// - Parameter invalidate: Set to true if you want to add the view to the parent
    @discardableResult
    public func addView(initialProps: InitialUIImageViewProps, invalidate: Bool = true) -> UIImageView {
        
        // set image
        let image = UIImage(named: initialProps.imageName)!
        let imgWidth = CGFloat(maxInnerSize * initialProps.widthPercentFromParent)
        let widthFactor = imgWidth/image.size.width
        let imgHeight = image.size.height * widthFactor
        
        // add the image
        let iv = UIImageView()
        iv.tag = initialProps.tag
        iv.translatesAutoresizingMaskIntoConstraints = false
        let ivWidthConstr = iv.widthAnchor.constraint(equalToConstant: imgWidth)
        ivWidthConstr.identifier = CONSTRAINT_WIDTH_ID
        ivWidthConstr.isActive = true
        iv.heightAnchor.constraint(equalToConstant: imgHeight).isActive = true
        iv.image = image
        if invalidate {
            beginViewAddProcedure(iv, [initialProps.alignment])
        }
        
        return iv
    }
    
    
    /// Will append a YoutubeVideoView
    ///
    /// - Parameter initialProps: The YoutubeVideo initial props
    /// - Parameter invalidate: Set to true if you want to add the view to the parent
    @discardableResult
    public func addView(initialProps: InitialYoutubeVideoProps,
                                invalidate: Bool = true) -> YTPlayerView {
        // set youtube video
        let ytPlayerView = YTPlayerView()
        ytPlayerView.translatesAutoresizingMaskIntoConstraints = false
        ytPlayerView.tag = initialProps.tag
        
        let ytWidth = CGFloat(maxInnerSize * initialProps.widthPercentFromParent)
        let ytHeight = ytWidth * initialProps.heightPercentFromWidth
        
        let ytWidthConstr = ytPlayerView.widthAnchor.constraint(equalToConstant: ytWidth)
        ytWidthConstr.identifier = CONSTRAINT_WIDTH_ID
        ytWidthConstr.isActive = true
        ytPlayerView.heightAnchor.constraint(equalToConstant: ytHeight).isActive = true
        loadYoutubeVideo(playerView: ytPlayerView, videoId: initialProps.videoId)
        if invalidate {
            beginViewAddProcedure(ytPlayerView, [initialProps.alignment])
        }
        return ytPlayerView
    }
    
    /// Will append a UIStackView
    ///
    /// - Parameter initialProps: The StackView initial props
    @discardableResult
    public func addView(initialProps: InitialStackViewProps, invalidate: Bool = true) -> UIStackView {
        var viewList = [UIView]()
        initialProps.subviewsInitialPropsList.forEach { it in
            switch it.getType() {
            case .label:
                viewList.append(addView(initialProps: it as! InitialLabelProps, invalidate: false))
            case .textView:
                viewList.append(addView(initialProps: it as! InitialUITextViewProps, invalidate: false))
            case .textField:
                viewList.append(addView(initialProps: it as! InitialUITextFieldProps, invalidate: false))
            case .imageView:
                viewList.append(addView(initialProps: it as! InitialUIImageViewProps, invalidate: false))
            case .youtubeVideo:
                viewList.append(addView(initialProps: it as! InitialYoutubeVideoProps, invalidate: false))
            case .button:
                viewList.append(addView(initialProps: it as! InitialButtonProps, invalidate: false))
            case .stackView:
                viewList.append(addView(initialProps: it as! InitialStackViewProps, invalidate: false))
            }
        }
        
        // sv
        let sv = UIStackView()
        sv.tag = tag
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = initialProps.axis
        sv.distribution = initialProps.distribution
        
        viewList.forEach { it in
            sv.addArrangedSubview(it)
        }
        sv.spacing = initialProps.spacing
        if invalidate {
            beginViewAddProcedure(sv, [.left, .right])
        }
        return sv
    }
    
    /// Will return any added view
    ///
    /// - Parameter tag: The view's tag you set
    public func getView<T: UIView>(tag: Int) -> T {
        return viewsContainer.viewWithTag(tag) as! T
    }
    
    /// Will attach the view to it's parent view. Call this function when you're done adding views and you want to pop the view
    ///
    /// - Parameter parentView: The parent view to attach to
    public func attachView(parentView: UIView, preventInteractionWithOtherViews: Bool = true) {
        // refresh the container
        viewsContainer.refreshLayout()
        
        // add the view and attach it to the top and centrelaize x
        parentView.addSubview(self)
        pinToParentTop(constant: margin)
        centralizeHorizontalInParent()
        
        // disable touches with other views, if required
        if preventInteractionWithOtherViews {
            toggleInteractionWithSiblingViews(interactable: false)
        }
        
        
        // attach bottom to bottom if height is too great
        if viewsContainer.frame.height > parentView.frame.height {
            pinToParentBottom()
        }
        subscribeKeyboardObservers()
    }
    
    
    private func loadYoutubeVideo(playerView: YTPlayerView, videoId: String) {
        playerView.load(withVideoId: videoId, playerVars: ["playsinline" : 1])
    }
    
    /// Will set the latest added view
    private func setVerticalLocation(_ view: UIView) {
        if let _latestViewAdded = latestViewAdded {
            view.topAnchor.constraint(equalTo: _latestViewAdded.bottomAnchor, constant: spaceBetweenViews).isActive = true
        } else {
            view.pinToParentTop(constant: padding)
        }
        
        latestViewAdded = view
    }
    
    // MARK: - keyboard observers
    func subscribeKeyboardObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Will detach any observers and remove from super view
    public override func removeFromSuperview() {
        unsubscribeKeyboardObservers()
        if !siblingViewsInteractable {
            toggleInteractionWithSiblingViews(interactable: true)
        }
        super.removeFromSuperview()
    }
    
    private func toggleInteractionWithSiblingViews(interactable: Bool) {
        siblingViewsInteractable = interactable
        superview!.subviews.forEach { it in
            if it.tag != UIDynamicView.VIEW_TAG {
                it.isUserInteractionEnabled = interactable
            }
        }
    }
    
    @objc func willShowKeyboard(notification: NSNotification) {
        containerViewTopConstrConst = containerViewTopConstr.constant
//        let info = notification.userInfo!
//        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let keyboardHeight = keyboardFrame.size.height
        if let currentView = firstResponder {
            let viewYLocation = currentView.frame.origin.y
            let scrolledY = scrollView.contentOffset.y
            let viewToTopConst = viewYLocation - scrolledY
            containerViewTopConstr.constant = -viewToTopConst + 16 // we will save a little bit of margin from the top
        }
    }
    
    @objc func willHideKeyboard()
    {
        containerViewTopConstr.constant = containerViewTopConstrConst
    }
    
    
    public static let VIEW_TAG = 95207
}


extension Array where Element == UIViewAlignment {
    
    /// Will append a bunch of items if they aren't exist in the array
    public mutating func appendIfNoExists(elements: [UIViewAlignment]) {
        elements.forEach { it in
            if !contains(it) {
                append(it)
            }
        }
        
    }
}

