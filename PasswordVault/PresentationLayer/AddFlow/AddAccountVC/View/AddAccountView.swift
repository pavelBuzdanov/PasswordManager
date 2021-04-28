//
//  AddAccountView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 20.04.2021.
//

import UIKit

class AddAccountView: UIView {
    
    // MARK: - Properties
    private var isSecure = true
    
    // MARK: - View
    lazy var nameLabel = self.createSectionsLabel(title: "Name")
    lazy var urlLabel = self.createSectionsLabel(title: "URL")
    lazy var usernameLabel = self.createSectionsLabel(title: "Username")
    lazy var passwordLabel = self.createSectionsLabel(title: "Password")
    lazy var noteLabel = self.createSectionsLabel(title: "Note")
    
    lazy var nameTextField = self.createTextField(placeholder: "Name of account", keyboardType: .default)
    lazy var urlTextField = self.createTextField(placeholder: "Website url", keyboardType: .URL)
    lazy var usernameTextField = self.createTextField(placeholder: "Username", keyboardType: .default)
    lazy var passwordTextField = self.createTextField(placeholder: "Password", keyboardType: .numbersAndPunctuation)
    
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
        [nameTextField, urlTextField, usernameTextField, passwordTextField].forEach { (view) in
            view.layer.cornerRadius = 10
        }
    }
    
    func lockEditing() {
        [nameTextField, urlTextField, usernameTextField, passwordTextField].forEach { (view) in
            view.isEnabled = false
        }
        
        textView.isEditable = false
    }
    
    func unlockEditing() {
        [nameTextField, urlTextField, usernameTextField, passwordTextField].forEach { (view) in
            view.isEnabled = true
        }
        
        textView.isEditable = true
    }
}

// MARK: - Private
private extension AddAccountView {
    
    // MARK: - SetupView
    func setupView() {
        layoutView()
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        nameTextField.font = .systemFont(ofSize: 20, weight: .medium)
        
        let button = UIButton(type: .custom)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.setImage(UIImage(named: "textFieldVisible"), for: .normal)
        button.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        passwordTextField.rightView = button
        passwordTextField.textColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
        passwordTextField.rightViewMode = .always
        passwordTextField.isSecureTextEntry = true
        
    }
    
    @objc func eyeButtonTapped () {
        isSecure.toggle()
        if isSecure {
            passwordTextField.textColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
            passwordTextField.isSecureTextEntry = true
        } else {
            passwordTextField.textColor = UIColor.TextField.textColor
            passwordTextField.isSecureTextEntry = false
        }
    }
    
    func layoutView() {
        
        let mainStack = UIStackView(arrangedSubviews: [
            createStackView(arrangedSubviews: [nameLabel, nameTextField]),
            createStackView(arrangedSubviews: [urlLabel, urlTextField]),
            createStackView(arrangedSubviews: [usernameLabel, usernameTextField]),
            createStackView(arrangedSubviews: [passwordLabel, passwordTextField]),
        ])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.distribution = .fillEqually
        mainStack.spacing = 20
        
        addSubview(mainStack)
        addSubview(noteLabel)
        addSubview(imageView)
        addSubview(textView)
        
        mainStack.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        noteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainStack.snp.bottom).offset(20)
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
extension AddAccountView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - UITextViewDelegate
extension AddAccountView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
