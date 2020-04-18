//
//  OperatorTimeoutViewController.swift
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

class OperatorTimeoutViewController: BaseOperatorViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectOutputCountdown = 5
        countdownFinishKillsPublisher = true
        
        subjects = [Subject(title: "Subject", publisher: publisher, inputValues: ["🌟", "✅", nil])]
        
        operators = [Operator(name: "timeout", description: "5 seconds")]
        
        subscription = timeout.sink(
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
        
        startCountdown()
        
        operatorInfo = "Terminates publishing if the upstream publisher exceeds the specified time interval without producing an element."
    }
    
    deinit {
        subscription?.cancel()
    }
    
    // MARK: - Private
    
    private let publisher = PassthroughSubject<String?, Never>()
    
    private lazy var timeout: Publishers.Timeout = {
        return publisher.timeout(5, scheduler: DispatchQueue.main)
    }()
    
    private var subscription: AnyCancellable?
    
}
