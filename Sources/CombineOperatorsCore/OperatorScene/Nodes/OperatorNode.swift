//
//  OperatorNode.swift
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

class OperatorNode: PublisherNode {
    
    let op: Operator
    
    init(op: Operator) {
        self.op = op
        super.init(texture: nil, color: .clear, size: CGSize(width: 100, height: 100))
        
        name = "operator"
        
        setupNodes()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateValues(_ values: [String], completion: @escaping () -> Void) {
        var wait: TimeInterval = 0
        for (index, value) in values.enumerated() {
            
            let valueNode = ValueNode(value: value, isOperator: true)
            addChild(valueNode)
            
            valueNode.position = CGPoint(x: 0, y: bandNode.frame.minY)
            
            valueNode.alpha = 0
            let waitAction = SKAction.wait(forDuration: wait)
            wait += 0.5
            let moveAction = SKAction.move(to: CGPoint(x: 0, y: bandNode.frame.maxY), duration: 1.0)
            let showAction = SKAction.fadeIn(withDuration: 0.0)
            let blinkAction = SKAction.wait(forDuration: 0.3)
            let disappearAction = SKAction.fadeOut(withDuration: 0.2)
            let sequence = SKAction.sequence([waitAction, showAction, moveAction, blinkAction, disappearAction])
            valueNode.run(sequence, completion: { [weak self, weak valueNode] in
                guard let valueNode = valueNode else { return }
                guard let self = self else { return }
                self.addOldValue(value: valueNode.value)
                valueNode.removeFromParent()
                if index == values.count - 1 {
                    completion()
                }
            })
        }
    }
    
    // MARK: - Private
    
    private lazy var bandNode: SKSpriteNode = {
        let node = BandNode(isOperator: true)
        return node
    }()
    
    private var oldValueNodes: [OldValueNode] = []
    
    private func setupNodes() {
        addChild(bandNode)
        bandNode.position = CGPoint(x: 0, y: size.height / 2 + bandNode.size.height / 2 - 10)
        
        let texture = SKTexture(image: Assets.operator.image)
        let bgNode = SKSpriteNode(
            texture: texture,
            color: .clear,
            size: CGSize(width: 100, height: 100)
        )
        addChild(bgNode)
        
        let labelNode = SKLabelNode()
        labelNode.text = "\(op.name)\n\(op.description ?? "")"
        labelNode.numberOfLines = 0
        labelNode.fontSize = 12.0
        labelNode.fontName = UIFont.boldSystemFont(ofSize: 12.0).familyName
        labelNode.fontColor = UIColor.black
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        addChild(labelNode)
    }
    
    private func addOldValue(value: String) {
        let node = OldValueNode(value: value, isOperator: true)
        oldValueNodes.append(node)
        insertChild(node, at: 0)
        layoutOldValueNodes()
    }
    
    private func layoutOldValueNodes() {
        var startX: CGFloat = bandNode.frame.minX - 20
        for node in oldValueNodes.reversed() {
            node.position.x = startX - node.size.width / 2
            node.position.y = bandNode.frame.maxY
            startX -= (node.size.width + 10)
        }
    }
    
}
