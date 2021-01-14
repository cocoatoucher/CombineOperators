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
        
        operatorInfo = "Collects and publishes elements each time a given interval is hit."
        
        operatorCode = """
            let subject = PassthroughSubject<String?, Error>()
            
            let collectByTime = subject
                .collect(.byTime(DispatchQueue.main, .seconds(5)))
            
            collectByTime
                .sink(
                    receiveValue: { values in
                        let result = values.map {
                            return $0 ?? "nil"
                        }
                        display(result.joined(separator: "-"))
                    }
                )
            """
    }
    
    override func setupBindings() {
        let subject1 = Subject(
            title: "Subject",
            inputValues: ["🌟", "✅", nil]
        )
        
        subjects = [subject1]
        
        let collectByTime = subject1.trackedPublisher!
            .collect(.byTime(DispatchQueue.main, .seconds(5)))
        
        subscription = collectByTime
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
                }, receiveValue: { [weak self] values in
                    guard let self = self else { return }
                    let result = values.map {
                        return $0 ?? "nil"
                    }
                    self.setValueFromOperator(value: result.joined(separator: "-"))
                }
            )
        
        startCountdown()
    }
    
}
