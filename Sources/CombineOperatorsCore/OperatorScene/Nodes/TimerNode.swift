//
//  TimerNode.swift
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

class TimerNode: SKSpriteNode {
    
    let startValue: CGFloat
    
    init(startValue: CGFloat) {
        self.startValue = startValue
        self.currentValue = startValue
        self.lastValue = startValue
        super.init(texture: nil, color: .clear, size: CGSize(width: 54, height: 54))
        
        setupNodes()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(currentValue: CGFloat, delta: TimeInterval) {
        self.currentValue = currentValue
        if self.currentValue < 0 {
            self.currentValue = 0
        }
        
        labelNode.text = "\(Int(ceil(self.currentValue)))"
        
        if ceil(lastValue) - ceil(currentValue) > 1 {
            lastValue = currentValue
            updateFill(to: currentValue)
            return
        }
        
        let targetValue = self.currentValue - 1
        let distanceToTarget = (lastValue - targetValue)
        let durationToTarget = distanceToTarget
        guard distanceToTarget > 0 else {
            return
        }
        let distance = distanceToTarget * (CGFloat(delta) / durationToTarget)
        
        self.lastValue = lastValue - distance
        guard lastValue > 0 else {
            return
        }
        
        updateFill(to: lastValue)
    }
    
    // MARK: - Private
    
    private var lastValue: CGFloat
    private var currentValue: CGFloat = 0
    
    private lazy var trackNode: SKShapeNode = {
        let node = SKShapeNode()
        node.lineCap = CGLineCap.round
        node.lineWidth = 5.0
        node.path = UIBezierPath(ovalIn: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)).cgPath
        node.strokeColor = Assets.countdownTrack.color
        node.fillColor = .clear
        return node
    }()
    
    private lazy var fillNode: SKShapeNode = {
        let node = SKShapeNode()
        node.lineCap = CGLineCap.round
        node.lineWidth = 5.0
        node.strokeColor = Assets.countdownFill.color
        node.fillColor = .clear
        return node
    }()
    
    private lazy var labelNode: SKLabelNode = {
        let label = SKLabelNode()
        label.verticalAlignmentMode = .center
        let font = UIFont.systemFont(ofSize: 14.0, weight: .heavy)
        label.fontSize = font.pointSize
        label.fontName = font.fontName
        label.fontColor = UIColor.black
        label.text = "\(Int(ceil(currentValue)))"
        return label
    }()
    
    private func setupNodes() {
        addChild(trackNode)
        addChild(fillNode)
        addChild(labelNode)
        
        updateFill(to: currentValue)
    }
    
    private func updateFill(to value: CGFloat) {
        let progress = (value / startValue) * (CGFloat.pi * 2)
        let path = UIBezierPath()
        path.addArc(withCenter: .zero,
                    radius: size.width / 2,
                    startAngle: (CGFloat.pi / 2),
                    endAngle: progress + (CGFloat.pi / 2),
                    clockwise: true)
        fillNode.path = path.cgPath
    }
    
}
