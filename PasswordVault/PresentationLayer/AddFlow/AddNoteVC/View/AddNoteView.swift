//
//  AddNoteView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 24.04.2021.
//

import UIKit

class AddNoteView: UIView {
    
    
    // MARK: - View
    lazy var nameLabel = self.createSectionsLabel(title: "Name")
    lazy var noteLabel = self.createSectionsLabel(title: "Note")
    
    lazy var nameTextField = self.createTextField(placeholder: "Name of account", keyboardType: .default)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "textViewBackground")
        return imageView
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = UIColor.TextField.textColor
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
    
    // MARK: - Object life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        imageView.layer.cornerRadius = 10
        [nameTextField].forEach { (view) in
            view.layer.cornerRadius = 10
        }
    }
    
    func lockEditing() {
        nameTextField.isEnabled = false
        textView.isEditable = false
    }
    
    func unlockEditing() {
        nameTextField.isEnabled = true
        textView.isEditable = true
    }
}

// MARK: - Private
private extension AddNoteView {
    
    // MARK: - SetupView
    func setupView() {
        layoutView()
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        nameTextField.font = .systemFont(ofSize: 20, weight: .medium)
    }
    
    func layoutView() {
        let nameStack = createStackView(arrangedSubviews: [nameLabel, nameTextField])
        
        addSubview(nameStack)
        addSubview(noteLabel)
        addSubview(imageView)
        addSubview(textView)
        
        nameStack.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(100)
        }
        
        noteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameStack.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(noteLabel.snp.bottom).offset(13)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-15)
        }

        textView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.top).offset(5)
            make.leading.equalTo(imageView.snp.leading).offset(20)
            make.trailing.equalTo(imageView.snp.trailing).offset(-20)
            make.bottom.equalTo(imageView.snp.bottom)

        }
        
        noteLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    func createStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.distribution = .fillProportionally
        return stackView
    }
    
    func createSectionsLabel(title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textColor = UIColor.Label.sectionLabelColor
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }
    
    func createTextField(placeholder: String, keyboardType: UIKeyboardType) -> PaddingTextField {
        let textField = PaddingTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.textColor = UIColor.TextField.textColor
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 10
        textField.background = UIImage(named: "textFieldBackground")
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.TextField.placeholderColor,
                                                                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
        return textField
    }
    
}

// MARK: - UITextFieldDelegate
extension AddNoteView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - UITextViewDelegate
extension AddNoteView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
