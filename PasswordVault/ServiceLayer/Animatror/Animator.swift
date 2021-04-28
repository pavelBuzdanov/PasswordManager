
import UIKit

struct Animator {
    // MARK: - Properties
    let handler: () -> Void
}

extension Animator {
    
    // MARK: - ScaleAnimation
    static func scaleAnimation(view: UIView, duration: TimeInterval, scaleX: CGFloat, scaleY: CGFloat) -> Animator {
        return Animator {
            UIView.animate(withDuration: duration/2, delay: 0.0, options: .allowUserInteraction) {
                view.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            } completion: { (_) in
                UIView.animate(withDuration: duration/2, delay: 0.0, options: .allowUserInteraction, animations: {
                    view.transform = .identity
                }, completion: nil)
            }
        }
    }
    
}
