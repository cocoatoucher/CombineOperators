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
    // Transforming
    case collect
    case map
    case replaceEmpty
    case replaceNil
    case scan
    
    // Filtering
    case filter
    case removeDuplicates
    case compactMap
    case ignoreOutput
    case first
    case last
    case dropFirst
    case dropWhile
    case prefix
    
    // Combining
    case prepend
    case append
    case merge
    case combineLatest
    case zip
    case flatMap
    case switchToLatest
    case dropUntilOutputFrom
    case prefixUntilOutputFrom
    
    // Timing
    case delay
    case measureInterval
    case collectByTime
    case debounce
    case throttle
    case timeout
    
    // Collecting
    case min
    case max
    case count
    case contains
    case outputAt
    case allSatisfy
    case reduce
    
    var sectionIndex: Int {
        switch self {
        
        // Transforming
        case .collect: return 0
        case .map: return 0
        case .replaceEmpty: return 0
        case .replaceNil: return 0
        case .scan: return 0
        
        // Filtering
        case .filter: return 1
        case .removeDuplicates: return 1
        case .compactMap: return 1
        case .ignoreOutput: return 1
        case .first: return 1
        case .last: return 1
        case .dropFirst: return 1
        case .dropWhile: return 1
        case .prefix: return 1
        
        // Combining
        case .prepend: return 2
        case .append: return 2
        case .merge: return 2
        case .combineLatest: return 2
        case .zip: return 2
        case .dropUntilOutputFrom: return 2
        case .prefixUntilOutputFrom: return 2
        case .flatMap: return 2
        case .switchToLatest: return 2
        
        // Timing
        case .delay: return 3
        case .measureInterval: return 3
        case .collectByTime: return 3
        case .debounce: return 3
        case .throttle: return 3
        case .timeout: return 3
        
        // Collecting
        case .min: return 4
        case .max: return 4
        case .count: return 4
        case .contains: return 4
        case .outputAt: return 4
        case .allSatisfy: return 4
        case .reduce: return 4
        }
    }
    
    static var sections: [[OperatorVariant]] {
        let section0 = Self.allCases.filter({ $0.sectionIndex == 0 })
        let section1 = Self.allCases.filter({ $0.sectionIndex == 1 })
        let section2 = Self.allCases.filter({ $0.sectionIndex == 2 })
        let section3 = Self.allCases.filter({ $0.sectionIndex == 3 })
        let section4 = Self.allCases.filter({ $0.sectionIndex == 4 })
        return [section0, section1, section2, section3, section4]
    }
}
