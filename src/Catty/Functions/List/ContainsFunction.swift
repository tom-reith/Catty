/**
 *  Copyright (C) 2010-2023 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

class ContainsFunction: DoubleParameterDoubleFunction {
    static var tag = "CONTAINS"
    static var name = kUIFEFunctionContains
    static var defaultValue = 0.0
    static var requiredResource = ResourceType.noResources
    static var isIdempotent = false
    static let position = 60

    func tag() -> String {
        type(of: self).tag
    }

    func firstParameter() -> FunctionParameter {
        .list(defaultValue: "list name")
    }

    func secondParameter() -> FunctionParameter {
        .number(defaultValue: 1)
    }

    func value(firstParameter: AnyObject?, secondParameter: AnyObject?) -> Double {
        guard let list = firstParameter as? UserList else {
                return type(of: self).defaultValue
        }

        if list.contains(where: { self.parameterMatch(firstParam: $0 as AnyObject, secondParam: secondParameter) }) {
            return 1.0
        }
        return 0.0

    }

    private func parameterMatch(firstParam: AnyObject?, secondParam: AnyObject?) -> Bool {
        let first = type(of: self).interpretParameter(parameter: firstParam)
        let second = type(of: self).interpretParameter(parameter: secondParam)
        return first == second
    }

    func formulaEditorSections() -> [FormulaEditorSection] {
        [.functions(position: type(of: self).position, subsection: .lists)]
    }
}
