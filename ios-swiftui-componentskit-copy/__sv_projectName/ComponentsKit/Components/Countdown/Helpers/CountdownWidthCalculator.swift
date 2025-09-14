import UIKit

@MainActor
struct CountdownWidthCalculator {
  private init() {}

  @MainActor static func preferredWidth(
    for attributedText: NSAttributedString,
    model: CountdownVM
  ) -> CGFloat {
    let label = UILabel()
    self.style(label, with: model)
    label.attributedText = attributedText

    let estimatedSize = label.sizeThatFits(UIView.layoutFittingExpandedSize)

    return estimatedSize.width + 2
  }

  @MainActor private static func style(_ label: UILabel, with model: CountdownVM) {
    label.textAlignment = .center
    label.numberOfLines = 0
  }
}
