//
//  OperatorScene.swift
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

class OperatorScene: TimeUpdatingScene {
    
    let subjects: [Subject]
    let operators: [Operator]
    
    var countdownFinishedCallback: (() -> Void)?
    
    var isCountingDown: Bool {
        return timerNode != nil
    }
    
    init(subjects: [Subject], operators: [Operator]) {
        self.subjects = subjects
        self.operators = operators
        super.init(size: .zero)
        
        scaleMode = .resizeFill
        backgroundColor = .white
        
        setupNodes()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        
        layout()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if currentCountdownValue < 0 {
            timerNode = nil
            currentCountdownValue = 0
            countdownFinishedCallback?()
        } else if currentCountdownValue > 0 {
            timerNode?.update(currentValue: CGFloat(currentCountdownValue), delta: lastDelta)
            currentCountdownValue -= lastDelta
        }
    }
    
    func startCountdown(for interval: TimeInterval) {
        let timerNode = TimerNode(startValue: CGFloat(interval))
        currentCountdownValue = interval
        self.timerNode = timerNode
    }
    
    func setValueForOperator(_ value: String, atIndex operatorIndex: Int) {
        operatorValues.append(value)
        if isAnimatingValue == false {
            displayOperatorValue(completion: nil)
        }
    }
    
    func setValueForSubject(_ value: String, atIndex subjectIndex: Int, completion: @escaping () -> Void) {
        
        isAnimatingValue = true
        let subjectNode = self.subjectNode(at: subjectIndex)
        subjectNode?.animateValue(value, completion: { [weak self] in
            guard let self = self else { return }
            self.isAnimatingValue = false
            guard self.operatorValues.count > 0 else {
                completion()
                return
            }
            self.displayOperatorValue(completion: completion)
        })
    }
    
    // MARK: - Private
    
    private let containerNode = SKNode()
    
    private let boardNode = SKSpriteNode(texture: nil, color: .white, size: CGSize(width: 400, height: 540))
    
    private let cameraNode = SKCameraNode()
    
    private var operatorValues: [String] = []
    
    private var isAnimatingValue: Bool = false
    
    private var timerNode: TimerNode? {
        didSet {
            oldValue?.removeFromParent()
            
            if let timerNode = timerNode {
                cameraNode.addChild(timerNode)
                layout()
            }
        }
    }
    
    private var currentCountdownValue: TimeInterval = 0
    
    private func setupNodes() {
        addChild(containerNode)
        
        containerNode.addChild(boardNode)
        
        for (index, subject) in subjects.enumerated() {
            let subjectNode = SubjectNode(subject: subject, pipeIsToRight: index > 0)
            boardNode.addChild(subjectNode)
        }
        
        for op in operators {
            let subjectNode = OperatorNode(op: op)
            boardNode.addChild(subjectNode)
        }
        
        camera = cameraNode
        addChild(cameraNode)
    }
    
    private func layout() {
        containerNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        var startX: CGFloat = -boardNode.size.width / 2
        for node in boardNode.children where node.name == "subject" {
            guard let subjectNode = node as? SubjectNode else {
                continue
            }
            if self.subjects.count > 1 {
                let gapWidth = (boardNode.size.width - (subjectNode.size.width * CGFloat(subjects.count))) / CGFloat(subjects.count + 1)
                
                subjectNode.position = CGPoint(x: startX + gapWidth + subjectNode.size.width / 2, y: -25)
                startX += subjectNode.size.width + gapWidth
            } else {
                subjectNode.position = CGPoint(x: -40, y: -25)
            }
        }
        
        for node in boardNode.children where node.name == "operator" {
            guard let operatorNode = node as? OperatorNode else {
                continue
            }
            guard let operatorIndex = operators.firstIndex(where: { $0.name == operatorNode.op.name }) else {
                continue
            }
            if subjects.count > 1 {
                guard let firstSubjectNode = boardNode.children.first(where: { $0.name == "subject" }) as? SKSpriteNode else {
                    continue
                }
                operatorNode.position = CGPoint(x: 0.0, y: firstSubjectNode.frame.maxY)
            } else {
                guard let subjectNode = boardNode.children.filter({ $0.name == "subject" })[operatorIndex] as? SKSpriteNode else {
                    continue
                }
                operatorNode.position = CGPoint(x: subjectNode.frame.maxX + 40, y: subjectNode.frame.maxY)
            }
        }
        
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        if let timerNode = timerNode {
            timerNode.position = CGPoint(x: size.width / 2 - 20 - timerNode.size.width / 2, y: size.height / 2 - 20 - timerNode.size.height / 2)
        }
        
        scaleBoardIfNeeded()
    }
    
    private func scaleBoardIfNeeded() {
        guard size.width > 0, size.height > 0 else {
            return
        }
        let boardSize = boardNode.frame.size
        
        let sideMargin: CGFloat = 8.0 * 2
        let requiredXScale = boardSize.width / (size.width - sideMargin)
        let requiredYScale = boardSize.height / (size.height - sideMargin)
        let finalScale = CGFloat.maximum(requiredXScale, requiredYScale)
        cameraNode.xScale = finalScale
        cameraNode.yScale = finalScale
    }
    
    private func subjectNode(at index: Int) -> SubjectNode? {
        return boardNode.children.filter({ $0.name == "subject" })[index] as? SubjectNode
    }
    
    private func operatorNode(at index: Int) -> OperatorNode? {
        return boardNode.children.filter({ $0.name == "operator" })[index] as? OperatorNode
    }
    
    private func displayOperatorValue(completion:  (() -> Void)? = nil) {
        guard let operatorNode = self.operatorNode(at: 0) else {
            completion?()
            return
        }
        
        let values = operatorValues
        self.operatorValues = []
        
        // Clean up subject values
        self.boardNode.children.filter { $0.name == "subject" }.forEach {
            ($0 as? SubjectNode)?.destroyValue(movesIntoOperator: true, isOperatorOnRight: $0.position.x < operatorNode.position.x)
        }
        
        operatorNode.animateValues(values) {
            completion?()
        }
    }
    
}
