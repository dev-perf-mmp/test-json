//
//  UIViewController+Utility.swift
//  Test-JSON
//
//  Created by Midhun on 03/08/18.
//  Copyright © 2018 Midhun. All rights reserved.
//  Utility extension for UIViewController

import UIKit
import SwiftMessages
import NVActivityIndicatorView

// MARK: Message
extension UIViewController
{
    /// Shows the info message banner
    ///
    /// - Parameters:
    ///   - tile: Text that need to be shown as title
    ///   - message: Text that need to be shown as the message
    func showInfoMessage(withTitle title: String, andMessage message: String)
    {
        self.showMessage(theme: Theme.info, title: title, message: message)
    }
    
    /// Shows the error message banner
    ///
    /// - Parameters:
    ///   - title: Text that need to be shown as title
    ///   - message: Text that need to be shown as the message
    func showErrorMessage(withTitle title: String, andMessage message: String)
    {
        self.showMessage(theme: Theme.error, title: title, message: message)
    }
    
    /// Method which configures and displays the message banner
    ///
    /// - Parameters:
    ///   - theme: Theme of banner
    ///   - title: Text that need to be shown as title
    ///   - message: Text that need to be shown as message
    private func showMessage(theme : Theme, title : String, message : String)
    {
        let layout            = Theme.error == theme ? MessageView.Layout.cardView : MessageView.Layout.messageView
        let view              = MessageView.viewFromNib(layout: layout)
        view.button?.isHidden = true
        
        // Theme message elements with the warning style.
        view.configureTheme(theme)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Set message title, body, and icon.
        view.configureContent(title: title, body: message, iconText: "")
        
        // Pause time between two messages
        SwiftMessages.pauseBetweenMessages = 1.0
        
        if theme == Theme.error
        {
            var config                    = SwiftMessages.defaultConfig
            config.duration               = .forever
            view.isUserInteractionEnabled = false
            // Show the message.
            SwiftMessages.show(config: config, view: view)
        }
        else
        {
            var config                    = SwiftMessages.defaultConfig
            config.duration               = .automatic
            // Show the message.
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    
    /// Hides all swift message instances
    func hideMessages()
    {
        SwiftMessages.hideAll()
    }
}

// MARK: Loading Indicator
extension UIViewController
{
    
    // Shows Loading Indicator
    func showLoading() -> UIView
    {
        var viewLoading:UIView?
        let window = UIApplication.shared.keyWindow
        
        if(viewLoading == nil)
        {
            
            viewLoading                  = UIView(frame: (window?.bounds)!)
            viewLoading?.backgroundColor = UIColor.darkGray
            viewLoading?.alpha           = 0.6
            let indicator                = NVActivityIndicatorView(frame:  CGRect(x: (viewLoading!.frame.width-88)/2, y: (viewLoading!.frame.height + 200)/2, width: 88, height: 30), type: NVActivityIndicatorType.ballPulseSync , color: UIColor.white)
            indicator.startAnimating()
            viewLoading?.addSubview(indicator)
        }
        
        window?.addSubview(viewLoading!)
        window?.bringSubview(toFront: viewLoading!)
        
        return viewLoading!
    }
    
    // Hide Loading
    func hideLoading(viewLoading: UIView)
    {
        viewLoading.removeFromSuperview()
    }
}
