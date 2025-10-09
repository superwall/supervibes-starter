import SwiftUI

/// Global UIKit appearance customizations.
///
/// ## Purpose
/// Global UIKit appearance proxy customizations that affect SwiftUI components.
///
/// ## Include
/// - UIKit appearance configurations (UIScrollView, UINavigationBar, UITableView, etc.)
/// - Global behavior tweaks
///
/// ## Don't Include
/// - SwiftUI-specific styling (use Theme.swift)
/// - Feature-specific logic
/// - Stateful configurations
///
/// ## Lifecycle & Usage
/// Called once during app initialization in __sv_projectNameApp.swift via `Appearance.configure()`.
///
// TODO: Configure UIKit appearance proxies here for global UI behavior
/// This affects all instances of UIKit components used by SwiftUI
@MainActor
struct Appearance {
  /// Apply all appearance customizations
  /// Call this once during app initialization
  static func configure() {
    // Disable content touch delays for more responsive buttons in ScrollViews
    UIScrollView.appearance().delaysContentTouches = false

    // TODO:  Add additional UIKit appearance customizations here
    // Examples:
    // UINavigationBar.appearance().tintColor = UIColor.systemBlue
    // UITableView.appearance().separatorStyle = .none
  }
}
