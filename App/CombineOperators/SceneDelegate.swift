//
//  SceneDelegate.swift
//  CombineOperators
//
//  Copyright (c) 2020 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import CombineOperatorsCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        #if targetEnvironment(macCatalyst)
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        UINavigationBar.appearance().tintColor = Assets.macNavBarTintColor.color
        
        windowScene.title = "Combine Operators"
        
        let splitViewController = UISplitViewController()
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.presentsWithGesture = false
        splitViewController.primaryBackgroundStyle = .sidebar

        let navigationController = UINavigationController(rootViewController: OperatorsTableViewController(isCompact: false))
        
        splitViewController.viewControllers = [navigationController]

        window?.rootViewController = splitViewController
        
        #else
        
        let splitViewController = UISplitViewController(style: .doubleColumn)
        splitViewController.preferredDisplayMode = .twoDisplaceSecondary
        splitViewController.presentsWithGesture = false
        splitViewController.preferredSplitBehavior = .tile

        let operatorsTableViewController = OperatorsTableViewController(isCompact: false)
        
        splitViewController.setViewController(operatorsTableViewController, for: .primary)
        
        let compactOperatorsTableViewController = OperatorsTableViewController(isCompact: true)
        let navigationController = UINavigationController(rootViewController: compactOperatorsTableViewController)
        splitViewController.setViewController(navigationController, for: .compact)

        window?.rootViewController = splitViewController
        
        #endif
    }
}
