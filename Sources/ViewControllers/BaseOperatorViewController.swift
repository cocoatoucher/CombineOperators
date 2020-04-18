//
//  BaseOperatorViewController.swift
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
import SpriteKit

class BaseOperatorViewController: UIViewController {
    
    var subjects: [Subject] = [] {
        didSet {
            setupSubjects()
        }
    }
    
    var operators: [Operator] = [] {
        didSet {
            updateScene()
        }
    }
    
    var operatorInfo: String?
    
    var subjectOutputCountdown: TimeInterval?
    var countdownFinishKillsPublisher: Bool = false
    var subjectValueRestartsCountdown: Bool = true
    var countdownFinishRestartsCountdown: Bool = false
    
    var isCountingDown: Bool {
        return (self.skView.scene as? OperatorScene)?.isCountingDown == true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    func setValueFromOperator(value: String?) {
        print("-- Operator received \(value ?? "nil")")
        
        (skView.scene as? OperatorScene)?.setValueForOperator(value ?? "nil", atIndex: 0)
    }
    
    func startCountdown() {
        if let subjectOutputCountdown = self.subjectOutputCountdown {
            (self.skView.scene as? OperatorScene)?.startCountdown(for: subjectOutputCountdown)
        }
    }
    
    // MARK: - Private
    
    private var subscriptions: [AnyCancellable] = []
    
    private lazy var skView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsTransparency = true
        view.showsFPS = false
        view.showsNodeCount = false
        view.ignoresSiblingOrder = false
        return view
    }()
    
    private lazy var subjectsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10.0
        stackView.axis = .vertical
        return stackView
    }()
    
    private var isInputButtonsEnabled: Bool = false {
        didSet {
            for view in subjectsStackView.arrangedSubviews {
                guard let subjectView = view as? SubjectView else {
                    continue
                }
                subjectView.isButtonsEnabled = isInputButtonsEnabled
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(skView)
        view.addSubview(subjectsStackView)
        
        let infoButton = UIBarButtonItem(image: UIImage.init(systemName: "info.circle"), style: .plain, target: self, action: #selector(displayInfo))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            skView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            skView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            skView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            subjectsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subjectsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subjectsStackView.topAnchor.constraint(equalTo: skView.bottomAnchor),
            subjectsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupSubjects() {
        for subview in subjectsStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        var subscriptions: [AnyCancellable] = []
        for (index, subject) in subjects.enumerated() {
            
            let subjectView = SubjectView(subject: subject)
            subjectView.inputButtonTapCallback = { subject, input in
                guard subject.isFinished == false else {
                    return
                }
                subject.publisher.send(input)
            }
            subjectView.completeButtonTapCallback = { subject in
                subject.publisher.send(completion: .finished)
            }
            subjectsStackView.addArrangedSubview(subjectView)
            
            let subscription = subject.publisher.handleEvents(receiveOutput: { [weak self] value in
                guard let self = self else { return }
                self.setValueForSubject(value, atIndex: index)
                
                if self.subjectValueRestartsCountdown {
                    self.startCountdown()
                }
            }, receiveCompletion: { [weak subjectView, weak subject] _ in
                guard let subjectView = subjectView else { return }
                guard let subject = subject else { return }
                subject.isFinished = true
                subjectView.isButtonsEnabled = false
            }).sink { _ in }
            
            subscriptions.append(subscription)
        }
        
        self.subscriptions = subscriptions
        
        updateScene()
    }
    
    private func updateScene() {
        let scene = OperatorScene(subjects: subjects, operators: operators)
        skView.presentScene(scene)
        scene.countdownFinishedCallback = { [weak self] in
            guard let self = self else {
                 return
            }
            if self.countdownFinishKillsPublisher {
                self.isInputButtonsEnabled = false
            } else if self.countdownFinishRestartsCountdown {
                self.startCountdown()
            }
        }
    }
    
    private func setValueForSubject(_ value: String?, atIndex subjectIndex: Int) {
        print("-- Subject \(subjectIndex + 1) received \(value ?? "nil")")
        
        isInputButtonsEnabled = false
        (skView.scene as? OperatorScene)?.setValueForSubject(value ?? "nil", atIndex: subjectIndex, completion: { [weak self] in
            guard let self = self else { return }
            self.isInputButtonsEnabled = true
        })
    }
    
    @objc private func displayInfo() {
        guard let operatorInfo = operatorInfo else {
            return
        }
        
        let viewController = OperatorInfoViewController(infoText: NSAttributedString(string: operatorInfo))
        
        viewController.modalPresentationStyle = .popover
        viewController.popoverPresentationController?.canOverlapSourceViewRect = false
        viewController.popoverPresentationController?.sourceView = navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView
        viewController.popoverPresentationController?.sourceRect = (navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView)?.frame ?? .zero
        viewController.popoverPresentationController?.permittedArrowDirections = .any
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
    }
    
}
