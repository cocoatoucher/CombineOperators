//
//  ViewController.swift
//  CombineOperatorsCore
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

open class OperatorsTableViewController: UITableViewController {
    
    let isCompact: Bool
    private var didSelectInitialRow: Bool = false
    
    public init(isCompact: Bool) {
        self.isCompact = isCompact
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        #if !targetEnvironment(macCatalyst)
        title = "Combine Operators"
        #endif
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "book"), style: .plain, target: self, action: #selector(displaySymbols))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OperatorCell")
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isCompact == false && didSelectInitialRow == false {
            
            let collectViewController = OperatorCollectViewController()
            collectViewController.title = "collect"
            updateSecondaryViewController(to: collectViewController)
            
            tableView.selectRow(
                at: IndexPath(row: 0, section: 0),
                animated: false,
                scrollPosition: .none
            )
            
            didSelectInitialRow = true
        }
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return OperatorVariant.sections.count
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OperatorVariant.sections[section].count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperatorCell", for: indexPath)
        
        let op = OperatorVariant.sections[indexPath.section][indexPath.row]
        cell.textLabel?.text = op.rawValue
        if isCompact {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let op = OperatorVariant.sections[indexPath.section][indexPath.row]
        guard let className = operatorViewControllerClassFromOperatorName(op.rawValue) as? BaseOperatorViewController.Type else {
            return
        }
        
        let viewController = className.init()
        viewController.title = op.rawValue
        
        if isCompact {
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            updateSecondaryViewController(to: viewController)
        }
    }
    
    public func updateSecondaryViewController(to viewController: UIViewController) {
        #if targetEnvironment(macCatalyst)
        
        let currentViewController = splitViewController?.viewControllers.last
        
        if object_getClass(currentViewController) == object_getClass(viewController) {
            return
        }
        
        let sidebar = splitViewController?.viewControllers.first
        let navigationController = UINavigationController(rootViewController: viewController)
        splitViewController?.viewControllers = [sidebar!, navigationController]
        #else
        
        let currentViewController = splitViewController?.viewController(for: .secondary)?.navigationController?.viewControllers.first
        
        if object_getClass(currentViewController) == object_getClass(viewController) {
            return
        }
        
        if isCompact {
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            if let navigationController = splitViewController?.viewController(for: .secondary)?.navigationController {
                navigationController.viewControllers = [viewController]
            } else {
                splitViewController?.setViewController(viewController, for: .secondary)
            }
        }
        #endif
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Transforming"
        case 1:
            return "Filtering"
        case 2:
            return "Combining"
        case 3:
            return "Timing"
        case 4:
            return "Collecting"
        default:
            return ""
        }
    }
    
    private func operatorViewControllerClassFromOperatorName(_ operatorName: String) -> AnyClass? {
        
        let nameCapitalized = operatorName.prefix(1).uppercased() + operatorName.dropFirst()
        let className = "Operator\(nameCapitalized)ViewController"
        
        return NSClassFromString("CombineOperatorsCore.\(className)")
    }
    
    @objc private func displaySymbols() {
        let symbolsViewController = SymbolsTableViewController()
        let navigationController = UINavigationController(rootViewController: symbolsViewController)
        present(navigationController, animated: true, completion: nil)
    }

}
