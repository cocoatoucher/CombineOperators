//
//  OperatorPrefixUntilOutputFromViewController.swift
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
import Combine

class OperatorPrefixUntilOutputFromViewController: BaseOperatorViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjects = [Subject(title: "Subject 1", publisher: publisher1, inputValues: ["🌟", "✅", nil]), Subject(title: "Subject 2", publisher: publisher2, inputValues: ["😎", "😱", nil])]
        
        operators = [Operator(name: "prefixUntilOutput", description: "from Subject 2")]
        
        subscription = prefixUntil.sink(
            receiveCompletion: { [weak self] _ in
                guard let self = self else { return }
                self.setValueFromOperator(value: "finished")
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                if let value = value {
                    self.setValueFromOperator(value: "\(value)")
                } else {
                    self.setValueFromOperator(value: nil)
                }
            })
        
        operatorInfo = "Prefixes this publisher’s output with the elements emitted by the given publisher until it receives an element from second publisher."
    }
    
    deinit {
        subscription?.cancel()
    }
    
    // MARK: - Private
    
    private let publisher1 = PassthroughSubject<String?, Never>()
    
    private let publisher2 = PassthroughSubject<String?, Never>()
    
    private lazy var prefixUntil: Publishers.PrefixUntilOutput = {
        return Publishers.PrefixUntilOutput(upstream: publisher1, other: publisher2)
    }()
    
    private var subscription: AnyCancellable?
    
}
