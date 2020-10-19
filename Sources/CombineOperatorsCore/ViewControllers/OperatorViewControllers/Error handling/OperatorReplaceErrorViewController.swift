//
//  OperatorReplaceErrorViewController.swift
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

class OperatorReplaceErrorViewController: BaseOperatorViewController {
    
    override func setupOperator() {
        operators = [Operator(name: "replaceError", description: "with 👻")]
        
        operatorInfo = "Replaces any errors in the stream with the provided element."
        
        operatorCode = """
            let subject = PassthroughSubject<String?, Error>
            
            let replaceError = subject
                .replaceError(with: "👻")
            
            replaceError
                .sink(
                    receiveValue: { value in
                        display(value)
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
        
        let replaceError = subject.trackedPublisher!
            .replaceError(with: "👻")
        
        subscription = replaceError
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
    }
    
}
