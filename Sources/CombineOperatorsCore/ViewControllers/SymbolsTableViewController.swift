//
//  SymbolsTableViewController.swift
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

open class SymbolsTableViewController: UITableViewController {
    
    let imageNames = ["link", "square.and.arrow.up", "xmark.circle", "exclamationmark.triangle", "checkmark"]
    let symbolTitles = ["Received subscription", "Received demand", "Cancelled", "Completed with error", "Completed"]
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Publisher Symbol Guide"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(performDismiss))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SymbolCell")
        tableView.allowsSelection = false
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SymbolCell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.imageView?.image = Assets.numberOfSubscriptions.image
            cell.textLabel?.text = "Number of subscriptions"
        } else {
            cell.imageView?.image = UIImage(systemName: imageNames[indexPath.row - 1])
            cell.textLabel?.text = symbolTitles[indexPath.row - 1]
        }
        
        return cell
    }
    
    @objc private func performDismiss() {
        dismiss(animated: true, completion: nil)
    }

}
