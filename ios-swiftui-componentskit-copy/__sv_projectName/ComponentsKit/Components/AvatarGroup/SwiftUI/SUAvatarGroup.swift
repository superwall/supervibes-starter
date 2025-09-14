import SwiftUI

/// A SwiftUI component that displays a group of avatars.
public struct SUAvatarGroup: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: AvatarGroupVM

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: AvatarGroupVM) {
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    HStack(spacing: self.model.spacing) {
      ForEach(self.model.identifiedAvatarVMs, id: \.0) { _, avatarVM in
        AvatarContent(model: avatarVM)
          .padding(self.model.padding)
          .background(self.model.borderColor.color)
          .clipShape(
            RoundedRectangle(cornerRadius: self.model.cornerRadius.value())
          )
          .frame(
            width: self.model.itemSize.width,
            height: self.model.itemSize.height
          )
      }
    }
  }
}
