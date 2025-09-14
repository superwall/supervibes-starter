import SwiftUI

/// A SwiftUI component that lets users select a value from a range by dragging a thumb along a track.
public struct SUSlider: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: SliderVM

  /// A binding to control the current value.
  @Binding public var currentValue: CGFloat

  private var progress: CGFloat {
    self.model.progress(for: self.currentValue)
  }

  // MARK: - Initializer

  /// Initializer.
  /// - Parameters:
  ///   - currentValue: A binding to the current value.
  ///   - model: A model that defines the appearance properties.
  public init(
    currentValue: Binding<CGFloat>,
    model: SliderVM = .init()
  ) {
    self._currentValue = currentValue
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    GeometryReader { geometry in
      let barWidth = self.model.barWidth(for: geometry.size.width, progress: self.progress)
      let backgroundWidth = self.model.backgroundWidth(for: geometry.size.width, progress: self.progress)

      HStack(spacing: self.model.trackSpacing) {
        // Progress segment
        RoundedRectangle(cornerRadius: self.model.cornerRadius(for: self.model.trackHeight))
          .foregroundStyle(self.model.color.main.color)
          .frame(width: barWidth, height: self.model.trackHeight)

        // Handle
        RoundedRectangle(cornerRadius: self.model.cornerRadius(for: self.model.handleSize.width))
          .foregroundStyle(self.model.color.main.color)
          .frame(width: self.model.handleSize.width, height: self.model.handleSize.height)
          .overlay(
            Group {
              if self.model.size == .large {
                RoundedRectangle(cornerRadius: self.model.cornerRadius(for: self.model.handleOverlaySide))
                  .foregroundStyle(self.model.color.contrast.color)
                  .frame(width: self.model.handleOverlaySide, height: self.model.handleOverlaySide)
              }
            }
          )
          .gesture(
            DragGesture(minimumDistance: 0)
              .onChanged { value in
                let totalWidth = geometry.size.width
                let sliderWidth = max(0, totalWidth - self.model.handleSize.width - 2 * self.model.trackSpacing)

                let currentLeft = barWidth
                let newOffset = currentLeft + value.translation.width

                let clampedOffset = min(max(newOffset, 0), sliderWidth)
                self.currentValue = self.model.steppedValue(for: clampedOffset, trackWidth: sliderWidth)
              }
          )

        // Remaining segment
        Group {
          switch self.model.style {
          case .light:
            RoundedRectangle(cornerRadius: self.model.cornerRadius(for: self.model.trackHeight))
              .foregroundStyle(self.model.color.background.color)
              .frame(width: backgroundWidth)
          case .striped:
            ZStack {
              RoundedRectangle(cornerRadius: self.model.cornerRadius(for: self.model.trackHeight))
                .foregroundStyle(.clear)

              StripesShapeSlider(model: self.model)
                .foregroundStyle(self.model.color.main.color)
                .cornerRadius(self.model.cornerRadius(for: self.model.trackHeight))
            }
            .frame(width: backgroundWidth)
          }
        }
        .frame(height: self.model.trackHeight)
      }
    }
    .frame(height: self.model.containerHeight)
    .onAppear {
      self.model.validateMinMaxValues()
    }
  }
}
// MARK: - Helpers

struct StripesShapeSlider: Shape, @unchecked Sendable {
  var model: SliderVM

  func path(in rect: CGRect) -> Path {
    self.model.stripesPath(in: rect)
  }
}
