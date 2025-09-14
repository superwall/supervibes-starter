import SwiftUI

/// A SwiftUI timer component that counts down from a specified duration to zero.
public struct SUCountdown: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: CountdownVM

  @State private var timeWidth: CGFloat = 70

  /// The countdown manager handling the countdown logic.
  @StateObject private var manager = CountdownManager()

  // MARK: - Initializer

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: CountdownVM) {
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    HStack(alignment: .top, spacing: self.model.spacing) {
      switch (self.model.style, self.model.unitsStyle) {
      case (.plain, .bottom):
        self.styledTime(value: self.manager.days, unit: .days)
        self.colonView
        self.styledTime(value: self.manager.hours, unit: .hours)
        self.colonView
        self.styledTime(value: self.manager.minutes, unit: .minutes)
        self.colonView
        self.styledTime(value: self.manager.seconds, unit: .seconds)

      case (.plain, .hidden), (.plain, .trailing):
        self.styledTime(value: self.manager.days, unit: .days)
        self.colonView
        self.styledTime(value: self.manager.hours, unit: .hours)
        self.colonView
        self.styledTime(value: self.manager.minutes, unit: .minutes)
        self.colonView
        self.styledTime(value: self.manager.seconds, unit: .seconds)

      case (.light, _):
        self.lightStyledTime(value: self.manager.days, unit: .days)
        self.lightStyledTime(value: self.manager.hours, unit: .hours)
        self.lightStyledTime(value: self.manager.minutes, unit: .minutes)
        self.lightStyledTime(value: self.manager.seconds, unit: .seconds)
      }
    }
    .onAppear {
      self.manager.start(until: self.model.until)
      self.timeWidth = self.model.timeWidth(manager: self.manager)
    }
    .onChange(of: self.model.until) { newDate in
      self.manager.stop()
      self.manager.start(until: newDate)
    }
    .onChange(of: self.model) { newValue in
      if newValue.shouldRecalculateWidth(self.model) {
        self.timeWidth = newValue.timeWidth(manager: self.manager)
      }
    }
    .onDisappear {
      self.manager.stop()
    }
  }

  // MARK: - Subviews

  private func styledTime(
    value: Int,
    unit: CountdownHelpers.Unit
  ) -> some View {
    let attributedString = AttributedString(self.model.timeText(value: value, unit: unit))
    return Text(attributedString)
      .multilineTextAlignment(.center)
      .frame(width: self.timeWidth)
  }

  private var colonView: some View {
    Text(":")
      .font(self.model.preferredMainFont.font)
      .foregroundColor(self.model.colonColor.color)
  }

  private func lightStyledTime(
    value: Int,
    unit: CountdownHelpers.Unit
  ) -> some View {
    return self.styledTime(value: value, unit: unit)
      .frame(minHeight: self.model.lightBackgroundMinHight)
      .frame(minWidth: self.model.lightBackgroundMinWidth)
      .background(RoundedRectangle(cornerRadius: 8)
        .fill(self.model.backgroundColor.color)
      )
  }
}
