
import UIKit

extension UIView {
    
    @discardableResult
    func gradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint, opacity: Float, location: [NSNumber]?) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map({  $0.cgColor })
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.opacity = opacity
        gradientLayer.locations = location
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
    
}
