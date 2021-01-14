//
//  OperatorCollectViewController.swift
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

public class OperatorCollectViewController: BaseOperatorViewController {
    
    override func setupOperator() {
        operators = [Operator(name: "collect", description: "count: 3")]
        
        operatorInfo = "Collects up to the specified number of elements, and then emits a single array of the collection."
        
        operatorCode = """
            let subject = PassthroughSubject<String?, Error>()
            
            let collect = subject.collect(3)
            
            collect
                .sink(
                    receiveValue: { values in
                        let mappedValues = values.map { $0 ?? "nil" }
                        display(mappedValues.joined(separator: " "))
                    }
                )
            """
    }
    
    override func setupBindings() {
        let subject = Subject(
            title: "Subject",
            inputValues: ["🌟", "✅", nil]
        )
        
        subjects = [subject]
        
        let collect = subject.trackedPublisher!.collect(3)
        
        subscription = collect
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
                    let mappedValues = values.map { $0 ?? "nil" }
                    self.setValueFromOperator(value: mappedValues.joined(separator: " "))
                }
            )
    }
}
