//
//  ViewController.swift
//  UIDynamicView
//
//  Created by osfunapps on 08/18/2020.
//  Copyright (c) 2020 osfunapps. All rights reserved.
//

import UIKit
import UIDynamicView
import OsTools

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        Tools.asyncMainTimedFunc(popFactsDialog, 2)
        Tools.asyncMainTimedFunc(popHelpDialog, 2)
    }
    
    private func popHelpDialog() {
        
        // build the dynamic view with all of the props
        dv = UIDynamicView()
        dv.prepareView(parentView: view,
                       padding: 14,
                       margin: 14,
                       maxWidthPercentFromParent: 0.65)
        dv.dropShadow(shadowRadius: 5.0)
        
        // add the title
        let topTitleProps = InitialLabelProps(text: "Help",
                                              textAlignment: .center,
                                              font: UIFont.systemFont(ofSize: 20, weight: .bold))
        dv.addView(initialProps: topTitleProps)

        // add the description
        let descriptionProps =  InitialLabelProps(text:
            """
            Please watch the below video to understand how to use the app
            """,
            textAlignment: .left,
            font: UIFont.systemFont(ofSize: 19)
        )
        dv.addView(initialProps: descriptionProps)

        // add the youtube video
        let videoProps = InitialYoutubeVideoProps(videoId: "BywDOO99Ia0",
                                                  widthPercentFromParent: 0.75,
                                                  alignment: .center)
        dv.addView(initialProps: videoProps)
        
        // add the footer button
        let okBtnProps = InitialButtonProps(labelText: "OK",
        alignment: .right,
        tapSelector: #selector(onOkBtnTap))
        
        dv.addView(initialProps: okBtnProps)
        dv.attachView(parentView: view)
    }
    
    
    private var dv: UIDynamicView!
    
    private func popFactsDialog() {
        
        // build the dynamic view with all of the props
        dv = UIDynamicView()
        dv.prepareView(parentView: view,
                       padding: 14,
                       margin: 14,
                       maxWidthPercentFromParent: 0.65)
        dv.dropShadow(shadowRadius: 5.0)
        
        // add the title
        let topTitleProps = InitialLabelProps(text: "New Features",
                                              textAlignment: .center,
                                              font: UIFont.systemFont(ofSize: 20, weight: .bold))
        dv.addView(initialProps: topTitleProps)
        
        // add the image
        let imgProps = InitialUIImageViewProps(imageName: "tt",
                                               widthPercentFromParent: 0.3,
                                               tag: 99,
                                               alignment: .center)
        dv.addView(initialProps: imgProps)
        
        // add the description
        let descriptionProps =  InitialLabelProps(text:
            """
            Teletubbies is a British children's television series
            created by Ragdoll Productions' Anne Wood and Andrew
            Davenport for BBC.
            """,
            textAlignment: .left,
            font: UIFont.systemFont(ofSize: 17)
        )
        dv.addView(initialProps: descriptionProps)
        
        // add the footer buttons
        let nextFactButton = InitialButtonProps(labelText: "Previous Fact",
        alignment: .left,
        tapSelector: #selector(onNextFactTap))
        
        let niceBtn = InitialButtonProps(labelText: "Next Fact!",
                                             alignment: .right,
                                             tapSelector: #selector(onNiceTap))
        let footerStackViewProps = InitialStackViewProps(subviewsInitialPropsList: [nextFactButton, niceBtn])
        
        dv.addView(initialProps: footerStackViewProps)
        dv.attachView(parentView: view)
    }
    
    @objc func onNiceTap() {
    }
    
    @objc func onNextFactTap() {
    }
    
    @objc func onOkBtnTap() {
        dv.fadeOut {
            self.dv.removeFromSuperview()
        }
    }
}

