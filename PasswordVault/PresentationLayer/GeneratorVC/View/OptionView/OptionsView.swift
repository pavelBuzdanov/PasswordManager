//
//  OptionsView.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import UIKit

class OptionsView: UIView {

    // MARK: - Properties
    // MARK: - Views
    private let passwordLenthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.text = "Password length"
        label.textColor = UIColor.Label.textColor
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let passwordLenthValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let slider: UISlider = {
       let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.maximumTrackTintColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
        slider.minimumTrackTintColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
        slider.thumbTintColor = #colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1)
        slider.maximumValue = 30
        slider.minimumValue = 8
        slider.value = 18
        slider.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
        return slider
    }()
    
    let sliderBackView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let upperCase = SingleOptionView(title: "Uppercase Chars")
    let lowerCase = SingleOptionView(title: "Lowercase Chars")
    let numbers = SingleOptionView(title: "Numbers")
    let specialSymbols = SingleOptionView(title: "Special Symbols")
    let brackets = SingleOptionView(title: "Brackets")
    
    private lazy var stackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [upperCase, lowerCase, numbers, specialSymbols, brackets])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Object lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradLayer = sliderBackView.gradient(colors: [#colorLiteral(red: 0.137254902, green: 0.1450980392, blue: 0.1568627451, alpha: 1), #colorLiteral(red: 0.1058823529, green: 0.1137254902, blue: 0.1254901961, alpha: 1)], startPoint: CGPoint(x: 0, y: 0),
                                           endPoint: CGPoint(x: 1, y: 1), opacity: 1.0, location: nil)
        gradLayer.cornerRadius =  sliderBackView.bounds.height/2
        sliderBackView.layer.cornerRadius = sliderBackView.bounds.height/2
        sliderBackView.clipsToBounds = true
    }
    
    // MARK: - SetupView
    private func setupView() {
        layoutView()
    }
    
    // MARK: - LayoutView
    private func layoutView() {
        passwordLenthValueLabel.text = "\(Int(slider.value))"
        addSubview(passwordLenthLabel)
        addSubview(passwordLenthValueLabel)
        addSubview(sliderBackView)
        addSubview(slider)
        addSubview(stackView)
        
        passwordLenthLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        passwordLenthValueLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(passwordLenthLabel.snp.trailing).offset(5)
            make.top.equalToSuperview()
        }
        
        sliderBackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(passwordLenthLabel.snp.bottom).offset(15)
            make.height.equalTo(30)
        }
        
        slider.snp.makeConstraints { (make) in
            make.centerY.equalTo(sliderBackView.snp.centerY)
            make.leading.equalTo(sliderBackView.snp.leading).offset(5)
            make.trailing.equalTo(sliderBackView.snp.trailing).offset(-5)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(sliderBackView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    private func buildPasswordOptions() -> (array:String, length: Int) {
        var string = ""
        
        if upperCase.swither.isOn {
            string.append("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        }
        
        if lowerCase.swither.isOn {
            string.append("abcdefghijklmnopqrstuvwxyz")
        }
        
        if specialSymbols.swither.isOn {
            string.append(";,&%$@#^*~/")
        }
        
        if numbers.swither.isOn {
            string.append("0123456789")
        }
        
        if brackets.swither.isOn {
            string.append("[]{}()")
        }
            
        let passwordLength = Int(slider.value)
        
        return (string,passwordLength)
    }
    
    func generatePassword() -> String {
        var password = ""
        let options = buildPasswordOptions()
        
        for _ in 0 ..< options.length {
            guard let element = options.array.randomElement() else { return "Invalid state"}
            password.append(element)
        }
        return password
    }

}

private extension OptionsView {
    
    @objc private func sliderChange() {
        passwordLenthValueLabel.text = "\(Int(slider.value))"
    }
    
}
