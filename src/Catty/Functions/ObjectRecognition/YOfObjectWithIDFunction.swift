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

class YOfObjectWithIDFunction: SingleParameterDoubleFunction {

    static let tag = "Y_OF_OBJECT_WITH_ID"
    static let name = kUIFEFunctionYOfObjectWithID
    static let defaultValue = 0.0
    static let isIdempotent = false
    static let position = 140
    static let requiredResource = ResourceType.objectRecognition

    let getVisualDetectionManager: () -> VisualDetectionManagerProtocol?
    let stageHeight: Double?

    init(stageSize: CGSize, visualDetectionManagerGetter: @escaping () -> VisualDetectionManagerProtocol?) {
        self.getVisualDetectionManager = visualDetectionManagerGetter
        self.stageHeight = Double(stageSize.height)
    }

    func tag() -> String {
        type(of: self).tag
    }

    func firstParameter() -> FunctionParameter {
        .number(defaultValue: 1)
    }

    func value(parameter: AnyObject?) -> Double {
        guard let idAsDouble = parameter as? Double,
              let visualDetectionManager = self.getVisualDetectionManager(),
              let stageHeight = self.stageHeight
        else { return type(of: self).defaultValue }

        let id = Int(idAsDouble)
        guard id >= 0 && id < visualDetectionManager.objectRecognitions.count else {
            return type(of: self).defaultValue
        }

        let boundingBox = visualDetectionManager.objectRecognitions[id].boundingBox
        let objectPositionY = boundingBox.origin.y + boundingBox.height / 2.0

        return stageHeight * objectPositionY - stageHeight / 2.0
    }

    func formulaEditorSections() -> [FormulaEditorSection] {
        [.sensors(position: type(of: self).position, subsection: .objectDetection)]
    }
}
