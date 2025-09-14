import SwiftUI

/// A SwiftUI component that displays a profile picture, initials or fallback icon for a user.
public struct SUAvatar: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: AvatarVM

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: AvatarVM) {
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    AvatarContent(model: self.model)
      .frame(
        width: self.model.preferredSize.width,
        height: self.model.preferredSize.height
      )
  }
}
