import SwiftUI

struct AvatarContent: View {
  // MARK: - Properties

  var model: AvatarVM

  @StateObject private var imageManager: AvatarImageManager
  @Environment(\.colorScheme) private var colorScheme

  // MARK: - Initialization

  init(model: AvatarVM) {
    self.model = model
    self._imageManager = StateObject(
      wrappedValue: AvatarImageManager(model: model)
    )
  }

  // MARK: - Body

  var body: some View {
    GeometryReader { geometry in
      Image(uiImage: self.imageManager.avatarImage)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .clipShape(
          RoundedRectangle(cornerRadius: self.model.cornerRadius.value())
        )
        .onAppear {
          self.imageManager.update(model: self.model, size: geometry.size)
        }
        .onChange(of: self.model) { newValue in
          self.imageManager.update(model: newValue, size: geometry.size)
        }
        .onChange(of: self.colorScheme) { _ in
          self.imageManager.update(model: self.model, size: geometry.size)
        }
    }
  }
}
