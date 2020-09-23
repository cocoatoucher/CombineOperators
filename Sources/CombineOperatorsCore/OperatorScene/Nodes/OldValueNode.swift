//
//  OldValueNode.swift
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

import SpriteKit

class OldValueNode: SKSpriteNode {
    
    let value: String?
    
    init(value: String?, isOperator: Bool = false) {
        self.value = value
        let color = isOperator ? Assets.operatorOldValue.color : Assets.subjectOldValue.color
        super.init(texture: nil, color: color, size: CGSize(width: 32, height: 24))
        
        name = "oldValue"
        
        setupNodes()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private lazy var labelNode: SKLabelNode = {
        let node = SKLabelNode()
        node.text = value
        node.fontSize = 12.0
        node.fontName = UIFont.boldSystemFont(ofSize: 12.0).familyName
        node.fontColor = UIColor.white
        node.horizontalAlignmentMode = .center
        node.verticalAlignmentMode = .center
        return node
    }()
    
    private func setupNodes() {
        if value?.hasPrefix("finished") == true {
            self.color = Assets.finishedRed.color
        }
        
        addChild(labelNode)
        
        let labelWidth = labelNode.calculateAccumulatedFrame().size.width
        let width = max(labelWidth + 10, 32)
        size.width = width
    }
    
}
