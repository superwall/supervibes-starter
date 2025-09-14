import Foundation

enum CheckboxAnimationDurations {
  static let background: CGFloat = 0.3
  static let checkmarkStroke: CGFloat = 0.2
  static let borderOpacity: CGFloat = 0.1
  static var checkmarkStrokeDelay: CGFloat {
    return self.background
  }
  static var selectedBorderDelay: CGFloat {
    return self.background * 2 / 3
  }
}
