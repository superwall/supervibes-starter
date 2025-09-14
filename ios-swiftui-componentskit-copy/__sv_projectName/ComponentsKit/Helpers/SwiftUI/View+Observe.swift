import SwiftUI

extension View {
  func observeSize(_ closure: @escaping (_ size: CGSize) -> Void) -> some View {
    return self.overlay(
      GeometryReader { geometry in
        Color.clear
          .onAppear {
            closure(geometry.size)
          }
          .onChange(of: geometry.size) { newValue in
            closure(newValue)
          }
      }
    )
  }
}
