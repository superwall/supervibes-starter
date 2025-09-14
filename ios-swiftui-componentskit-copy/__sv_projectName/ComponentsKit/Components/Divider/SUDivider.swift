import SwiftUI

/// A SwiftUI component that displays a separating line.
public struct SUDivider: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: DividerVM

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: DividerVM = .init()) {
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    Rectangle()
      .fill(self.model.lineColor.color)
      .frame(
        maxWidth: self.model.orientation == .vertical ? self.model.lineSize : nil,
        maxHeight: self.model.orientation == .horizontal ? self.model.lineSize : nil
      )
  }
}
