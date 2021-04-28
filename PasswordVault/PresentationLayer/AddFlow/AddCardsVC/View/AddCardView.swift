//
//  AddCardView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 24.04.2021.
//

import UIKit
import TLCustomMask

class AddCardView: UIView {
    
    // MARK: - Properties
    private var isSecure = true
    private let cardMask: TLCustomMask = {
        let mask = TLCustomMask()
        mask.formattingPattern = "$$$$ $$$$ $$$$ $$$$"
        return mask
    }()
    
    private let dateMask: TLCustomMask = {
        let mask = TLCustomMask()
        mask.formattingPattern = "$$ / $$"
        return mask
    }()
    
    // MARK: - View
    lazy var nameLabel = self.createSectionsLabel(title: "Name")
    lazy var cardholderLabel = self.createSectionsLabel(title: "Cardholder Name")
    lazy var cardNumberLabel = self.createSectionsLabel(title: "Card Number")
    lazy var cardTypeLabel = self.createSectionsLabel(title: "Card Type")
    lazy var pinLabel = self.createSectionsLabel(title: "Pin")
    lazy var cvvLabel = self.createSectionsLabel(title: "CVV")
    lazy var dateLabel = self.createSectionsLabel(title: "Expired Date")
    lazy var noteLabel = self.createSectionsLabel(title: "Note")
    
    lazy var nameTextField = self.createTextField(placeholder: "Name of card", keyboardType: .default)
    lazy var cardholderTextField = self.createTextField(placeholder: "Cardholder Name", keyboardType: .default)
    lazy var cardNumberTextField = self.createTextField(placeholder: "Card Number", keyboardType: .default)
    lazy var cardtypeTextField = self.createTextField(placeholder: "Visa, Mastercard ...", keyboardType: .default)
    lazy var pinTextField = self.createTextField(placeholder: "Pin", keyboardType: .numberPad)
    lazy var cvvTextField = self.createTextField(placeholder: "CVV", keyboardType: .numberPad)
    lazy var dateTextField = self.createTextField(placeholder: "MM/YY", keyboardType: .numberPad)
    
    
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
        [nameTextField,cardholderTextField, cardNumberTextField, cardtypeTextField, pinTextField, cvvTextField ].forEach { (view) in
            view.isEnabled = false
        }
        textView.isEditable = false
    }
    
    func unlockEditing() {
        [nameTextField,cardholderTextField, cardNumberTextField, cardtypeTextField, pinTextField, cvvTextField ].forEach { (view) in
            view.isEnabled = true
        }
        textView.isEditable = true
    }
}

// MARK: - Private
private extension AddCardView {
    
    // MARK: - SetupView
    func setupView() {
        layoutView()
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        nameTextField.font = .systemFont(ofSize: 20, weight: .medium)
        
        setupSecureTextFilds(textField: cvvTextField, tag: 0)
        setupSecureTextFilds(textField: pinTextField,tag: 1)
        
    }
    
    private func setupSecureTextFilds(textField: UITextField, tag: Int) {
        let button = UIButton(type: .custom)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.setImage(UIImage(named: "textFieldVisible"), for: .normal)
        button.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        button.tag = tag
        textField.rightView = button
        textField.textColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
        textField.rightViewMode = .always
        textField.isSecureTextEntry = true
    }
    
    @objc func eyeButtonTapped (_ sender: UIButton) {
        switch sender.tag {
        case 0:
            changeTextField(textField: cvvTextField)
        case 1:
            changeTextField(textField: pinTextField)
        default:
            return
        }
    }
    
    private func changeTextField(textField: UITextField) {
        if textField.isSecureTextEntry == false {
            textField.textColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
            textField.isSecureTextEntry = true
        } else {
            textField.textColor = UIColor.TextField.textColor
            textField.isSecureTextEntry = false
        }
    }
    
    
    func layoutView() {
        
        let mainStack = UIStackView(arrangedSubviews: [
            createStackView(arrangedSubviews: [nameLabel, nameTextField]),
            createStackView(arrangedSubviews: [cardholderLabel, cardholderTextField]),
            createStackView(arrangedSubviews: [cardNumberLabel, cardNumberTextField]),
            createStackView(arrangedSubviews: [cardTypeLabel, cardtypeTextField]),
            createStackView(arrangedSubviews: [pinLabel, pinTextField]),
            createStackView(arrangedSubviews: [cvvLabel, cvvTextField]),
            createStackView(arrangedSubviews: [dateLabel, dateTextField]),
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
extension AddCardView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == cardNumberTextField {
            textField.text = cardMask.formatStringWithRange(range: range, string: string)
        } else if textField == dateTextField {
            textField.text = dateMask.formatStringWithRange(range: range, string: string)
        } else {
            return true
        }
        
        return false
    }
}

// MARK: - UITextViewDelegate
extension AddCardView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
