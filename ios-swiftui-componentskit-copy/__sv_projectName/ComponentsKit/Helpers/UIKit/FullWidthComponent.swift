import UIKit

/// A base-class for views whose intrinsic content size depends on the
/// width of their super-view (e.g. full width button, input field, etc.).
///
/// By inheriting from `FullWidthComponent` the component gets automatic
/// `invalidateIntrinsicContentSize()` calls whenever the device rotates, the
/// window is resized (iPad multitasking, Stage Manager) or the view moves
/// into a different container with a new width.
open class FullWidthComponent: UIView {
  private var lastKnownParentWidth: CGFloat = .nan

  open override func layoutSubviews() {
    super.layoutSubviews()

    guard let parentWidth = self.superview?.bounds.width else { return }

    if parentWidth != self.lastKnownParentWidth {
      self.lastKnownParentWidth = parentWidth

      // Defer to the next run-loop tick so the current layout pass
      // finishes with the new parent size first.
      DispatchQueue.main.async {
        self.invalidateIntrinsicContentSize()
      }
    }
  }
}
