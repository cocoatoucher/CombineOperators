//
//  PublisherNode.swift
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

class PublisherNode: SKSpriteNode {
    
    private var pendingIcons: [String] = []
    
    var numberOfSubscriptions: Int = 0 {
        didSet {
            subscriptionsLabelNode.text = "\(numberOfSubscriptions)"
            subscriptionsNode.isHidden = numberOfSubscriptions == 0
        }
    }
    
    lazy var subscriptionsNode: SKShapeNode = {
        let node = SKShapeNode(circleOfRadius: 10)
        node.fillColor = .blue
        node.strokeColor = .clear
        node.addChild(subscriptionsLabelNode)
        node.isHidden = true
        return node
    }()
    
    lazy var subscriptionsLabelNode: SKLabelNode = {
        let node = SKLabelNode()
        node.fontSize = 10.0
        node.fontName = UIFont.boldSystemFont(ofSize: 10.0).familyName
        node.fontColor = UIColor.white
        node.horizontalAlignmentMode = .center
        node.verticalAlignmentMode = .center
        return node
    }()
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        addChild(subscriptionsNode)
        subscriptionsNode.position = CGPoint(x: size.width / 2 - 16, y: -size.height / 2 + 16)
        subscriptionsNode.zPosition = 100
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func markUpdate(_ update: PublisherUpdate) {
        switch update {
        case .subscription:
            animateIconNamed("link")
        case .subscriptionCount(let count):
            numberOfSubscriptions = count
        case .request:
            animateIconNamed("square.and.arrow.up")
        case .cancel:
            animateIconNamed("xmark.circle")
        case .completion(let isError):
            if isError {
                animateIconNamed("exclamationmark.triangle")
            } else {
                animateIconNamed("checkmark")
            }
        default:
            break
        }
    }
    
    private func animateIconNamed(_ iconName: String) {
        guard pendingIcons.isEmpty else {
            pendingIcons.append(iconName)
            return
        }
        
        pendingIcons.append(iconName)
        animatePendingIcon()
    }
    
    private func animatePendingIcon() {
        guard let iconName = pendingIcons.first else {
            return
        }
        
        let image = UIImage(systemName: iconName)!.applyingSymbolConfiguration(.init(font: .boldSystemFont(ofSize: 48.0), scale: .large))!
        let node = SKSpriteNode(texture: SKTexture(image: image))
        addChild(node)
        
        node.setScale(0.1)
        
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.3)
        let fadeOut = SKAction.fadeAlpha(to: 0.2, duration: 0.3)
        let group = SKAction.group([scaleUp, fadeOut])
        let wait = SKAction.wait(forDuration: 0.1)
        let sequence = SKAction.sequence([group, wait])
        node.run(sequence) { [weak self] in
            guard let self = self else { return }
            node.removeFromParent()
            self.pendingIcons.removeFirst()
            self.animatePendingIcon()
        }
    }
}
