//
//  AddDocumentView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 24.04.2021.
//

import UIKit
import TLCustomMask

class AddDocumentView: UIView {
    
    // MARK: - Properties
    
    private let phoneMask: TLCustomMask = {
        let mask = TLCustomMask()
        mask.formattingPattern = "+$ $$$ $$$ $$ $$"
        return mask
    }()
    
    private let  birthdayMask: TLCustomMask = {
        let mask = TLCustomMask()
        mask.formattingPattern = "$$/$$/$$$$"
        return mask
    }()

    
    // MARK: - View
    lazy var nameLabel = self.createSectionsLabel(title: "Name")
    lazy var firstnameLabel = self.createSectionsLabel(title: "First Name")
    lazy var lastnameLabel = self.createSectionsLabel(title: "Last Name")
    lazy var birthdayLabel = self.createSectionsLabel(title: "Birthday")
    lazy var jobLabel = self.createSectionsLabel(title: "Job")
    lazy var addressLabel = self.createSectionsLabel(title: "Address")
    lazy var noteLabel = self.createSectionsLabel(title: "Note")
    lazy var emailLabel = self.createSectionsLabel(title: "Email")
    lazy var phoneLabel = self.createSectionsLabel(title: "Phone")
    
    lazy var nameTextField = self.createTextField(placeholder: "Name of document", keyboardType: .default)
    lazy var firtnameField = self.createTextField(placeholder: "First Name", keyboardType: .default)
    lazy var lastnameField = self.createTextField(placeholder: "Last Name", keyboardType: .default)
    lazy var birthdayField = self.createTextField(placeholder: "Birthday", keyboardType: .default)
    lazy var jobTextField = self.createTextField(placeholder: "Job", keyboardType: .default)
    lazy var addressTextField = self.createTextField(placeholder: "Address", keyboardType: .default)
    lazy var emailTextField = self.createTextField(placeholder: "Address", keyboardType: .default)
    lazy var phoneTextField = self.createTextField(placeholder: "+0 000 000 00 00", keyboardType: .numberPad)
    
    
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
    }
    
    func lockEditing() {
        [nameTextField, firtnameField, lastnameField, birthdayField, jobTextField, addressTextField, phoneTextField,emailTextField].forEach { (view) in
            view.isEnabled = false
        }
        textView.isEditable = false
    }
    
    func unlockEditing() {
        [nameTextField, firtnameField, lastnameField, birthdayField, jobTextField, addressTextField, phoneTextField,emailTextField].forEach { (view) in
            view.isEnabled = true
        }
        textView.isEditable = true
    }
}

// MARK: - Private
private extension AddDocumentView {
    
    // MARK: - SetupView
    func setupView() {
        layoutView()
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        nameTextField.font = .systemFont(ofSize: 20, weight: .medium)
        
    }
    
    func layoutView() {
        
        let mainStack = UIStackView(arrangedSubviews: [
            createStackView(arrangedSubviews: [nameLabel, nameTextField]),
            createStackView(arrangedSubviews: [firstnameLabel, firtnameField]),
            createStackView(arrangedSubviews: [lastnameLabel, lastnameField]),
            createStackView(arrangedSubviews: [birthdayLabel, birthdayField]),
            createStackView(arrangedSubviews: [jobLabel, jobTextField]),
            createStackView(arrangedSubviews: [emailLabel, emailTextField]),
            createStackView(arrangedSubviews: [phoneLabel, phoneTextField]),
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
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        noteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainStack.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(16)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(noteLabel.snp.bottom).offset(13)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-15)
        }

        textView.snp.makeConstraints { (make) in
            make.top.equalTo(noteLabel.snp.bottom).offset(18)
            make.leading.equalTo(imageView.snp.leading).offset(20)
            make.trailing.equalTo(imageView.snp.trailing).offset(-20)
            make.bottom.equalTo(imageView.snp.bottom).offset(-5)
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
extension AddDocumentView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneTextField {
            textField.text = phoneMask.formatStringWithRange(range: range, string: string)
        } else if textField == birthdayField {
            textField.text = birthdayMask.formatStringWithRange(range: range, string: string)
        } else {
            return true
        }
        return false
    }
}

// MARK: - UITextViewDelegate
extension AddDocumentView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
