//
//  SubjectNode.swift
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

class SubjectNode: SKSpriteNode {
    
    let subject: Subject
    let pipeIsToRight: Bool
    
    init(subject: Subject, pipeIsToRight: Bool = false) {
        self.subject = subject
        self.pipeIsToRight = pipeIsToRight
        super.init(texture: nil, color: .clear, size: CGSize(width: 100, height: 100))
        
        name = "subject"
        
        setupNodes()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateValue(_ value: String, completion: @escaping () -> Void) {
        destroyValue(movesIntoOperator: false)
        
        let valueNode = ValueNode(value: value)
        addChild(valueNode)
        
        valueNode.position = CGPoint(x: 0, y: bandNode.frame.minY)
        
        let moveAction = SKAction.move(to: CGPoint(x: 0, y: bandNode.frame.maxY + size.height), duration: 1.0)
        valueNode.run(moveAction, completion: completion)
    }
    
    func destroyValue(movesIntoOperator: Bool, isOperatorOnRight: Bool = true) {
        let valueNode = children.first(where: { $0.name == "value" })
        let disappear = SKAction.fadeOut(withDuration: 0.3)
        var action: SKAction
        if movesIntoOperator {
            let moveAmount: CGFloat = (isOperatorOnRight) ? 50.0 : -50.0
            let moveRight = SKAction.moveBy(x: moveAmount, y: 0, duration: 0.3)
            action = SKAction.group([disappear, moveRight])
        } else {
            action = disappear
        }
        valueNode?.run(action, completion: { [weak self, weak valueNode] in
            guard let self = self else { return }
            if let oldValue = (valueNode as? ValueNode)?.value {
                self.addOldValue(value: oldValue)
            }
            valueNode?.removeFromParent()
        })
    }
    
    // MARK: - Private
    
    private lazy var bandNode: SKSpriteNode = {
        let node = BandNode()
        return node
    }()
    
    private lazy var labelNode: SKLabelNode = {
        let node = SKLabelNode()
        node.numberOfLines = 0
        node.text = subject.title
        node.fontSize = 16.0
        node.fontName = UIFont.systemFont(ofSize: 16, weight: .heavy).familyName
        node.fontColor = UIColor.white
        node.horizontalAlignmentMode = .center
        node.verticalAlignmentMode = .center
        return node
    }()
    
    private var oldValueNodes: [OldValueNode] = []
    
    private func setupNodes() {
        addChild(bandNode)
        bandNode.position = CGPoint(x: 0, y: -size.height / 2 - bandNode.size.height / 2)
        
        let pipeNode = self.pipeNode(toRight: pipeIsToRight)
        if pipeIsToRight {
            pipeNode.position.x = -65.0
            pipeNode.position.y = -10.0
        } else {
            pipeNode.position.x = 65.0
            pipeNode.position.y = -10.0
        }
        addChild(pipeNode)
        
        let bgNode = SKSpriteNode(texture: SKTexture(imageNamed: "subject"), color: .clear, size: CGSize(width: 100, height: 100))
        addChild(bgNode)
        
        addChild(labelNode)
    }
    
    private func pipeNode(toRight: Bool) -> SKSpriteNode {
        if toRight {
            return SKSpriteNode(texture: SKTexture(imageNamed: "pipe_right"), color: .clear, size: CGSize(width: 82, height: 82))
        } else {
            return SKSpriteNode(texture: SKTexture(imageNamed: "pipe_left"), color: .clear, size: CGSize(width: 82, height: 82))
        }
    }
    
    private func addOldValue(value: String) {
        let node = OldValueNode(value: value)
        oldValueNodes.append(node)
        insertChild(node, at: 0)
        layoutOldValueNodes()
    }
    
    private func layoutOldValueNodes() {
        var startX: CGFloat = size.width / 2 - 20.0
        for node in oldValueNodes.reversed() {
            node.position.x = startX - node.size.width / 2
            node.position.y = size.height / 2 + node.size.height / 2 + 10
            startX -= (node.size.width + 10)
        }
    }
    
}
