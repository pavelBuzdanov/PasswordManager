//
//  Slider.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.


import UIKit

class CustomSlider: UISlider {

    var trackHeight: CGFloat = 3

    var thumbRadius: CGFloat = 20 {
        didSet {
            let thumb = thumbImage(radius: thumbRadius)
            setThumbImage(thumb, for: .normal)
        }
    }
    
    var thumbColor: UIColor = .yellow

    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = thumbColor
        thumb.layer.borderWidth = 0.4
        thumb.layer.borderColor = UIColor.darkGray.cgColor
        return thumb
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        let thumb = thumbImage(radius: thumbRadius)
        setThumbImage(thumb, for: .normal)
    }

    private func thumbImage(radius: CGFloat) -> UIImage {
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }

}
