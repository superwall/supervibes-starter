import SwiftUI

/// Reusable editor components for UserField types in settings.
///
/// ## Purpose
/// Reusable editor components for UserField types in settings.
///
/// ## Include
/// - UserFieldTextEditor (right-aligned text input)
/// - UserFieldSingleSelectionEditor (native Picker)
/// - UserFieldMultiSelectionEditor (sheet with checkable list)
/// - MultiSelectionSheet
///
/// ## Don't Include
/// - Onboarding-specific UI (step views handle that)
/// - User model definition
/// - Validation beyond UI presentation
///
/// ## Lifecycle & Usage
/// Used in UserSettingsView to render editable fields; driven by UserField definitions; provides Settings-optimized UI (compact, list-friendly).

/// Text field editor for user fields (used in settings)
// TODO: Right-aligned text field with no padding or border for settings lists
struct UserFieldTextEditor: View {
  let field: any UserField
  @Binding var value: String
  var isRequired: Bool = false

  var body: some View {
    if case .textField(let placeholder) = field.inputType {
      HStack {
        Text(field.displayName)
        Spacer()
        TextField(placeholder, text: $value)
          .multilineTextAlignment(.trailing)
          .foregroundStyle(Theme.Colors.secondaryText)
          .textContentType(.name)
          .autocapitalization(.words)
      }
    }
  }
}

/// Single selection editor for settings (uses native Picker)
// TODO: Dropdown picker for single selection in settings
struct UserFieldSingleSelectionEditor: View {
  let field: any UserField
  @Binding var value: String?

  var body: some View {
    if case .singleSelection(let options) = field.inputType {
      Picker(field.displayName, selection: $value) {
        Text("Not set").tag(nil as String?)
        ForEach(options, id: \.self) { option in
          Text(option).tag(option as String?)
        }
      }
    }
  }
}

/// Multi selection editor for settings (opens sheet with selection list)
// TODO: Button that opens sheet for multiple selection
struct UserFieldMultiSelectionEditor: View {
  let field: any UserField
  @Binding var values: [String]
  @State private var showingSheet = false

  var displayText: String {
    if values.isEmpty {
      return "None"
    } else {
      return "\(values.count) selected"
    }
  }

  var body: some View {
    if case .multiSelection(let options) = field.inputType {
      Button {
        showingSheet = true
      } label: {
        HStack {
          Text(field.displayName)
            .foregroundStyle(Theme.Colors.primaryText)
          Spacer()
          Text(displayText)
            .foregroundStyle(Theme.Colors.secondaryText)
          Image(systemName: "chevron.right")
            .font(.caption)
            .foregroundStyle(Theme.Colors.secondaryText)
        }
      }
      .sheet(isPresented: $showingSheet) {
        MultiSelectionSheet(
          title: field.displayName,
          icon: field.icon,
          options: options,
          selectedValues: $values
        )
        .presentationDetents([.medium])
      }
    }
  }
}

// MARK: - Multi Selection Sheet

/// Sheet view for selecting multiple values
// TODO: Full-screen sheet with list of checkable options
struct MultiSelectionSheet: View {
  let title: String
  let icon: String
  let options: [String]
  @Binding var selectedValues: [String]

  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      List {
        ForEach(options, id: \.self) { option in
          Button {
            toggleSelection(option)
          } label: {
            HStack(spacing: 12) {
              // Show icon for interests if available
              if let interest = InterestsField.Interest(rawValue: option) {
                Image(systemName: interest.icon)
                  .foregroundStyle(Theme.Colors.primary)
                  .frame(width: 24)
              }

              Text(option)
                .foregroundStyle(Theme.Colors.primaryText)

              Spacer()

              if selectedValues.contains(option) {
                Image(systemName: "checkmark")
                  .foregroundStyle(Theme.Colors.primary)
              }
            }
          }
        }
      }
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Image(systemName: icon)
            .foregroundStyle(Theme.Colors.primary)
        }

        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") {
            dismiss()
          }
        }
      }
    }
  }

  private func toggleSelection(_ option: String) {
    if selectedValues.contains(option) {
      selectedValues.removeAll { $0 == option }
    } else {
      selectedValues.append(option)
    }
  }
}

#Preview {
  MultiSelectionSheet(
    title: "Interests",
    icon: "star.circle.fill",
    options: ["Cooking", "Sports", "Music", "Reading"],
    selectedValues: .constant(["Cooking", "Sports"])
  )
}
