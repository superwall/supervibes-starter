import SwiftUI

// MARK: - Transparent Presentation Background

fileprivate struct TransparentBackground: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = .clear
    }
    return view
  }
  func updateUIView(_ uiView: UIView, context: Context) {}
}

extension View {
  func transparentPresentationBackground() -> some View {
    if #available(iOS 16.4, *) {
      return self.presentationBackground(Color.clear)
    } else {
      return self.background(TransparentBackground())
    }
  }
}

// MARK: - Disable Scroll When Content Fits

extension View {
  func disableScrollWhenContentFits() -> some View {
    if #available(iOS 16.4, *) {
      return self.scrollBounceBehavior(.basedOnSize, axes: [.vertical])
    } else {
      return self.onAppear {
        UIScrollView.appearance().bounces = false
      }
    }
  }
}
