//
//  SubjectView.swift
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

class SubjectView: UIView {
    
    let subject: Subject
    
    var inputButtonTapCallback: ((Subject, String?) -> Void)?
    var errorButtonTapCallback: ((Subject) -> Void)?
    var completeButtonTapCallback: ((Subject) -> Void)?
    
    var isButtonsEnabled: Bool = true {
        didSet {
            updateButtons()
        }
    }
    
    init(subject: Subject) {
        self.subject = subject
        super.init(frame: .zero)
        
        setupViews()
        updateButtons()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, buttonsStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10.0
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = .black
        label.text = subject.title
        return label
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10.0
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private func setupViews() {
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        for value in subject.inputValues {
            let button = InputButton()
            button.setTitle(value ?? "nil", for: .normal)
            button.addTarget(self, action: #selector(handleInputButtonTap), for: .touchUpInside)
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            buttonsStackView.addArrangedSubview(button)
        }
        
        // Error button
        let errorButton = InputButton(mode: .error)
        errorButton.setTitle("Error", for: .normal)
        errorButton.addTarget(self, action: #selector(handleErrorButtonTap), for: .touchUpInside)
        errorButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonsStackView.addArrangedSubview(errorButton)
        
        // Complete button
        let completeButton = InputButton(mode: .finish)
        completeButton.setTitle("Finish", for: .normal)
        completeButton.addTarget(self, action: #selector(handleCompleteButtonTap), for: .touchUpInside)
        completeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonsStackView.addArrangedSubview(completeButton)
    }
    
    @objc private func handleErrorButtonTap(sender: UIButton) {
        errorButtonTapCallback?(subject)
    }
    
    @objc private func handleCompleteButtonTap(sender: UIButton) {
        completeButtonTapCallback?(subject)
    }
    
    @objc private func handleInputButtonTap(sender: UIButton) {
        guard let buttonIndex = buttonsStackView.arrangedSubviews.firstIndex(of: sender) else {
            return
        }
        let inputValue = subject.inputValues[buttonIndex]
        inputButtonTapCallback?(subject, inputValue)
    }
    
    func updateButtons() {
        let isEnabled = isButtonsEnabled && subject.isFinished == false && subject.numberOfSubcriptions > 0
        titleLabel.isEnabled = isEnabled
        buttonsStackView.arrangedSubviews.forEach({ ($0 as? UIButton)?.isEnabled = isEnabled })
    }
    
}
