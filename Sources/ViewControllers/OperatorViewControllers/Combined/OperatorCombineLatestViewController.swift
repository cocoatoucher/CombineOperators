//
//  OperatorCombineLatestViewController.swift
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

class OperatorCombineLatestViewController: BaseOperatorViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjects = [Subject(title: "Subject 1", publisher: publisher1, inputValues: ["🌟", "✅", nil]), Subject(title: "Subject 2", publisher: publisher2, inputValues: ["😎", "😱", nil])]
        
        operators = [Operator(name: "combineLatest", description: nil)]
        
        subscription = combinedLatest.sink(
            receiveCompletion: { [weak self] _ in
                guard let self = self else { return }
                self.setValueFromOperator(value: "finished")
            }, receiveValue: { [weak self] firstValue, secondValue in
                guard let self = self else { return }
                self.setValueFromOperator(value: "\(firstValue ?? "nil") - \(secondValue ?? "nil")")
            })
        
        operatorInfo = "A publisher that receives and combines the latest elements from two publishers."
    }
    
    deinit {
        subscription?.cancel()
    }
    
    // MARK: - Private
    
    private let publisher1 = PassthroughSubject<String?, Never>()
    
    private let publisher2 = PassthroughSubject<String?, Never>()
    
    private lazy var combinedLatest: Publishers.CombineLatest = {
        return Publishers.CombineLatest(publisher1, publisher2)
    }()
    
    private var subscription: AnyCancellable?
    
}
