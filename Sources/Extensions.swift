//
//  Extensions.swift
//  blescan
//
//  Created by Hannes Ljungberg on 2019-05-16.
//
//  Based on https://github.com/erica/SwiftInterpolation/

import Foundation

extension String.StringInterpolation {
    /// Interpolates using a custom string formatter, allowing the results to
    /// be padded as desired, for example:
    ///
    /// ```
    /// "\("23", .format(width: 5))" // "23   "
    /// "\("23", .format(alignment: .right, width: 5))" // "   23"
    /// ```
    /// - Parameters:
    ///   - value: a value to present
    ///   - formatter: a string formatter
    mutating func appendInterpolation<Value>(
        _ value: Value,
        _ formatter: StringFormatter,
        width: Int = 0
    ) {
        if width != 0 { formatter.width = width }
        appendLiteral(formatter.string(from: "\(value)"))
    }
}

class StringFormatter {
   enum TextAlignment { case left, right, center }
   var alignment: TextAlignment = .left
   var paddingCharacter: Character = " "
   var width = 0

   init(
        alignment: TextAlignment = .left,
        paddingCharacter: Character = " ",
        width: Int = 0
    ) {
        (self.alignment, self.paddingCharacter, self.width) = (
            alignment,
            paddingCharacter,
            width
        )
    }

    static func format(
        alignment: TextAlignment = .left,
        paddingCharacter: Character = " ",
        width: Int = 0
    ) -> StringFormatter {
        return StringFormatter(
            alignment: alignment,
            paddingCharacter: paddingCharacter,
            width: width
        )
    }

    func string(from string: StringLiteralType) -> StringLiteralType {
        guard width > string.count else { return string }
        let corePadCount = max(width - string.count, 0)

        func padding(_ count: Int) -> String {
            return String(repeating: paddingCharacter, count: count)
        }

        switch alignment {
        case .right:
            return padding(corePadCount) + string
        case .left:
            return string + padding(corePadCount)
        case .center:
            let halfPad = corePadCount / 2
            return padding(corePadCount - halfPad) + string + padding(halfPad)
        }
    }
}
