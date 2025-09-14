import UIKit

/// A model that defines the appearance properties for an avatar group component.
public struct AvatarGroupVM: ComponentVM {
  /// The border color of avatars.
  public var borderColor: UniversalColor = .background

  /// The color of the placeholders.
  public var color: ComponentColor?

  /// The corner radius of the avatars.
  ///
  /// Defaults to `.full`.
  public var cornerRadius: ComponentRadius = .full

  /// The array of avatars in the group.
  public var items: [AvatarItemVM] = [] {
    didSet {
      self._identifiedItems = self.items.map({
        return .init(id: UUID(), item: $0)
      })
    }
  }

  /// The maximum number of visible avatars.
  ///
  /// Defaults to `5`.
  public var maxVisibleAvatars: Int = 5

  /// The predefined size of the component.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The array of avatar items with an associated id value to properly display content in SwiftUI.
  private var _identifiedItems: [IdentifiedAvatarItem] = []

  /// Initializes a new instance of `AvatarGroupVM` with default values.
  public init() {}
}

// MARK: - Helpers

fileprivate struct IdentifiedAvatarItem: Equatable {
  var id: UUID
  var item: AvatarItemVM
}

extension AvatarGroupVM {
  var identifiedAvatarVMs: [(UUID, AvatarVM)] {
    var avatars = self._identifiedItems.prefix(self.maxVisibleAvatars).map { data in
      return (data.id, AvatarVM {
        $0.color = self.color
        $0.cornerRadius = self.cornerRadius
        $0.imageSrc = data.item.imageSrc
        $0.placeholder = data.item.placeholder
        $0.size = self.size
      })
    }

    if self.numberOfHiddenAvatars > 0 {
      avatars.append((UUID(), AvatarVM {
        $0.color = self.color
        $0.cornerRadius = self.cornerRadius
        $0.placeholder = .text("+\(self.numberOfHiddenAvatars)")
        $0.size = self.size
      }))
    }

    return avatars
  }

  var itemSize: CGSize {
    switch self.size {
    case .small:
      return .init(width: 36, height: 36)
    case .medium:
      return .init(width: 48, height: 48)
    case .large:
      return .init(width: 64, height: 64)
    }
  }

  var padding: CGFloat {
    switch self.size {
    case .small:
      return 3
    case .medium:
      return 4
    case .large:
      return 5
    }
  }

  var spacing: CGFloat {
    return -self.itemSize.width / 3
  }

  var numberOfHiddenAvatars: Int {
    return max(0, self.items.count - self.maxVisibleAvatars)
  }
}

// MARK: - UIKit Helpers

extension AvatarGroupVM {
  var avatarHeight: CGFloat {
    return self.itemSize.height - self.padding * 2
  }
  var avatarWidth: CGFloat {
    return self.itemSize.width - self.padding * 2
  }
}
