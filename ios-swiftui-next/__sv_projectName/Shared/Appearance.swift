import SwiftUI

/// Global UIKit appearance customizations
/// TEMPLATE NOTE: Configure UIKit appearance proxies here for global UI behavior
/// This affects all instances of UIKit components used by SwiftUI
@MainActor
struct Appearance {
  /// Apply all appearance customizations
  /// Call this once during app initialization
  static func configure() {
    // Disable content touch delays for more responsive buttons in ScrollViews
    UIScrollView.appearance().delaysContentTouches = false

    // TEMPLATE NOTE: Add additional UIKit appearance customizations here
    // Examples:
    // UINavigationBar.appearance().tintColor = UIColor.systemBlue
    // UITableView.appearance().separatorStyle = .none
  }
}
