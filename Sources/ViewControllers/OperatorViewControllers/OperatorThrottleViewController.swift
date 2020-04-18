//
//  OperatorThrottleViewController.swift
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

class OperatorThrottleViewController: BaseOperatorViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectOutputCountdown = 6
        subjectValueRestartsCountdown = false
        countdownFinishRestartsCountdown = false
        
        subjects = [Subject(title: "Subject", publisher: publisher, inputValues: ["🌟", "✅", nil])]
        
        operators = [Operator(name: "throttle", description: "6 seconds")]
        
        subscription = throttled.sink(
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
                
                self.startCountdown()
            })
        
        operatorInfo = "A publisher that publishes either the most-recent or first element published by the upstream publisher in a specified time interval."
    }
    
    deinit {
        subscription?.cancel()
    }
    
    // MARK: - Private
    
    private let publisher = PassthroughSubject<String?, Never>()
    
    private lazy var throttled: Publishers.Throttle = {
        return Publishers.Throttle(upstream: publisher, interval: 6, scheduler: DispatchQueue.main, latest: true)
    }()
    
    private var subscription: AnyCancellable?
    
}
