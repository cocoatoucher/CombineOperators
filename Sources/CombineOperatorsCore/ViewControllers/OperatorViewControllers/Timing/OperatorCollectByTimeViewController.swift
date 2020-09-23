//
//  OperatorCollectByTimeViewController.swift
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

class OperatorCollectByTimeViewController: BaseOperatorViewController {
    
    override func setupOperator() {
        subjectOutputCountdown = 5
        subjectValueRestartsCountdown = false
        countdownFinishRestartsCountdown = true
        
        operators = [Operator(name: "collectByTime", description: "5 seconds")]
        
        operatorInfo = """
            Collects and publishes elements each time a given interval is hit.
            `.collect(.byTime(DispatchQueue.main, .seconds(5)))`
        """
    }
    
    override func setupBindings() {
        let subject1 = Subject(
            title: "Subject",
            inputValues: ["🌟", "✅", nil]
        )
        
        subjects = [subject1]
        
        let last = subject1.trackedPublisher!
            .collect(.byTime(DispatchQueue.main, .seconds(5)))
        
        subscription = last
            .handleEvents(
                receiveSubscription: { [weak self] _ in
                    guard let self = self else { return }
                    self.updateOperator(.subscription)
                }, receiveCancel: { [weak self] in
                    guard let self = self else { return }
                    self.updateOperator(.cancel)
                }, receiveRequest: { [weak self] _ in
                    guard let self = self else { return }
                    self.updateOperator(.request)
                }
            )
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.setCompletionFromOperator(completion: completion)
                }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    let result = value.map { val -> String in
                        if let val = val {
                            return val
                        } else {
                            return "nil"
                        }
                    }
                    let str = result.joined(separator: "-")
                    self.setValueFromOperator(value: str)
                }
            )
        
        startCountdown()
    }
    
}
