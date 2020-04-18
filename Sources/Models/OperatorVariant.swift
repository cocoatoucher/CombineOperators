//
//  OperatorVariant.swift
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

import Foundation

enum OperatorVariant: String, CaseIterable {
    case map
    case compactMap
    case flatMap
    case filter
    case reduce
    case replaceNil
    case debounce
    case removeDuplicates
    case first
    case replaceEmpty
    case ignoreOutput
    case dropFirst
    case dropWhile
    case last
    case throttle
    case timeout
    case collect
    
    case combineLatest
    case zip
    case merge
    case append
    case prepend
    case multicast
    case dropUntilOutputFrom
    case prefixUntilOutputFrom
    
    var sectionIndex: Int {
        switch self {
        case .map: return 0
        case .compactMap: return 0
        case .flatMap: return 0
        case .filter: return 0
        case .reduce: return 0
        case .replaceNil: return 0
        case .debounce: return 0
        case .removeDuplicates: return 0
        case .first: return 0
        case .replaceEmpty: return 0
        case .ignoreOutput: return 0
        case .dropFirst: return 0
        case .dropWhile: return 0
        case .last: return 0
        case .throttle: return 0
        case .timeout: return 0
        case .collect: return 0
        
        case .combineLatest: return 1
        case .zip: return 1
        case .merge: return 1
        case .append: return 1
        case .prepend: return 1
        case .multicast: return 1
        case .dropUntilOutputFrom: return 1
        case .prefixUntilOutputFrom: return 1
        }
    }
    
    static var sections: [[OperatorVariant]] {
        let section0 = Self.allCases.filter({ $0.sectionIndex == 0 })
        let section1 = Self.allCases.filter({ $0.sectionIndex == 1 })
        return [section0, section1]
    }
}
