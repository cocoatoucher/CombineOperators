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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Combine Operators"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OperatorCell")
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
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let op = OperatorVariant.sections[indexPath.section][indexPath.row]
        guard let className = operatorViewControllerClassFromOperatorName(op.rawValue) as? BaseOperatorViewController.Type else {
            return
        }
        let viewController = className.init()
        viewController.title = op.rawValue
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Simple Operators"
        }
        return "Combined Operators"
    }
    
    private func operatorViewControllerClassFromOperatorName(_ operatorName: String) -> AnyClass? {
        
        let nameCapitalized = operatorName.prefix(1).uppercased() + operatorName.dropFirst()
        let className = "Operator\(nameCapitalized)ViewController"
        
        return NSClassFromString("CombineOperatorsCore.\(className)")
    }

}
