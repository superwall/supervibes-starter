import SwiftUI
import UIKit

extension CircularProgressVM {
  /// Defines the style of line endings.
  public enum LineCap {
    /// The line ends with a semicircular arc that extends beyond the endpoint, creating a rounded appearance.
    case rounded
    /// The line ends exactly at the endpoint with a flat edge.
    case square
  }
}

// MARK: - UIKit Helpers

extension CircularProgressVM.LineCap {
  var shapeLayerLineCap: CAShapeLayerLineCap {
    switch self {
    case .rounded:
      return .round
    case .square:
      return .butt
    }
  }
}

// MARK: - SwiftUI Helpers

extension CircularProgressVM.LineCap {
  var cgLineCap: CGLineCap {
    switch self {
    case .rounded:
      return .round
    case .square:
      return .butt
    }
  }
}
