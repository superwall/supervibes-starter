import SwiftUI
import UIKit

@MainActor
final class AvatarImageManager: ObservableObject {
  @Published var avatarImage: UIImage

  private var model: AvatarVM
  private static var remoteImagesCache = NSCache<NSString, UIImage>()

  init(model: AvatarVM) {
    self.model = model

    let size = model.preferredSize
    switch model.imageSrc {
    case .remote(let url):
      self.avatarImage = model.placeholderImage(for: size)
      self.downloadImage(url: url)
    case let .local(name, bundle):
      self.avatarImage = UIImage(named: name, in: bundle, compatibleWith: nil) ?? model.placeholderImage(for: size)
    case .none:
      self.avatarImage = model.placeholderImage(for: size)
    }
  }

  func update(model: AvatarVM, size: CGSize) {
    self.model = model

    switch model.imageSrc {
    case .remote(let url):
      if let image = Self.remoteImagesCache.object(forKey: url.absoluteString as NSString) {
        self.avatarImage = image
      } else {
        self.avatarImage = model.placeholderImage(for: size)
        self.downloadImage(url: url)
      }
    case let .local(name, bundle):
      self.avatarImage = UIImage(named: name, in: bundle, compatibleWith: nil) ?? model.placeholderImage(for: size)
    case .none:
      self.avatarImage = model.placeholderImage(for: size)
    }
  }

  private func downloadImage(url: URL) {
    Task {
      let request = URLRequest(url: url)
      guard let (data, _) = try? await URLSession.shared.data(for: request),
            let image = UIImage(data: data)
      else { return }

      await MainActor.run {
        Self.remoteImagesCache.setObject(image, forKey: url.absoluteString as NSString)
        if url == self.model.imageURL {
          self.avatarImage = image
        }
      }
    }
  }
}
