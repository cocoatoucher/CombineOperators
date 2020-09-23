//
//  InputButton.swift
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

class InputButton: UIButton {
    
    enum Mode {
        case value
        case error
        case finish
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.3
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = UIColor(
                    named: "\(colorNamePrefix)Highlighted",
                    in: Bundle.module,
                    compatibleWith: nil
                )
            } else {
                backgroundColor = UIColor(
                    named: colorNamePrefix,
                    in: Bundle.module,
                    compatibleWith: nil
                )
            }
        }
    }
    
    let colorNamePrefix: String
    
    init(mode: Mode = .value) {
        switch mode {
        case .value:
            colorNamePrefix = "inputButton"
        case .error:
            colorNamePrefix = "errorButton"
        case .finish:
            colorNamePrefix = "finishButton"
        }
        
        super.init(frame: .zero)
        
        setTitleColor(.black, for: .normal)
        backgroundColor = UIColor(
            named: colorNamePrefix,
            in: Bundle.module,
            compatibleWith: nil
        )
        layer.cornerRadius = 4.0
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
