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
    
    override func setupOperator() {
        subjectOutputCountdown = 5
        countdownFinishKillsPublisher = true
        
        operators = [Operator(name: "timeout", description: "5 seconds")]
        
        operatorInfo = "Terminates publishing if the upstream publisher exceeds the specified time interval without producing an element."
        
        operatorCode = """
            let subject = PassthroughSubject<String?, Error>()
            
            let timeout = subject
                .timeout(5, scheduler: DispatchQueue.main)
            
            timeout
                .sink(
                    receiveValue: { value in
                        display(value)
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
        
        let timeout = subject1.trackedPublisher!
            .timeout(5, scheduler: DispatchQueue.main)
        
        subscription = timeout
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
                    self.setValueFromOperator(value: value)
                }
            )
        
        startCountdown()
    }
    
}
