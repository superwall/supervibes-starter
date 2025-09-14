import UIKit

extension UIView {
  /// Whether the view is visible.
  var isVisible: Bool {
    get {
      return !self.isHidden
    }
    set {
      self.isHidden = !newValue
    }
  }
}

extension UIView {
  /// A helper to get bounds of the device's screen.
  public var screenBounds: CGRect {
    return self.window?.windowScene?.screen.bounds ?? UIScreen.main.bounds
  }
}
