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

@objc extension ChangeVolumeByNBrick: CBInstructionProtocol {

    @nonobjc func instruction() -> CBInstruction {

        guard let spriteObject = self.script?.object else { fatalError("This should never happen!") }

        return CBInstruction.execClosure { context, scheduler in
            let audioEngine = scheduler.getAudioEngine()
            let volumeChange = context.formulaInterpreter.interpretDouble(self.volume, for: spriteObject)

            audioEngine.changeVolumeBy(percent: volumeChange, key: nil)
            context.state = .runnable
        }
    }
}
