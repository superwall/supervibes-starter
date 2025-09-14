import Foundation

extension Optional {
  /// Whether the value is nil.
  var isNil: Bool {
    return self == nil
  }

  /// Whether the value is not nil.
  var isNotNil: Bool {
    return self != nil
  }
}

extension Optional where Wrapped: Collection {
  /// Whether the value is not nil and empty.
  var isNotNilAndEmpty: Bool {
    if let self {
      return self.isNotEmpty
    } else {
      return false
    }
  }

  /// Whether the value is nil or empty.
  var isNilOrEmpty: Bool {
    if let self {
      return self.isEmpty
    } else {
      return true
    }
  }
}
