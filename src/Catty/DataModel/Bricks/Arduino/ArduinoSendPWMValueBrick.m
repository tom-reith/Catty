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

#import "ArduinoSendPWMValueBrick.h"
#import "Script.h"

@implementation ArduinoSendPWMValueBrick

- (kBrickCategoryType)category
{
    return kArduinoBrick;
}

- (Formula*)formulaForLineNumber:(NSInteger)lineNumber andParameterNumber:(NSInteger)paramNumber
{
    if(lineNumber == 0)
        return self.pin;
    else if(lineNumber == 1)
        return self.value;
    
    return nil;
}

- (void)setFormula:(Formula*)formula forLineNumber:(NSInteger)lineNumber andParameterNumber:(NSInteger)paramNumber
{
    if(lineNumber == 0)
        self.pin = formula;
    else if(lineNumber == 1)
        self.value = formula;
}

- (NSArray*)getFormulas
{
    return @[self.pin,self.value];
}

- (BOOL)allowsStringFormula
{
    return NO;
}

#pragma mark - Description
- (NSString*)description
{
    return [NSString stringWithFormat:@"ArduinoSendPWMValueBrick"];
}

- (BOOL)isEqualToBrick:(Brick*)brick
{
    if (![self.pin isEqualToFormula:((ArduinoSendPWMValueBrick*)brick).pin]) {
        return NO;
    }
    if (![self.value isEqualToFormula:((ArduinoSendPWMValueBrick*)brick).value]) {
        return NO;
    }
    return YES;
}

#pragma mark - Default values
- (void)setDefaultValuesForObject:(SpriteObject*)spriteObject
{
    self.pin = [[Formula alloc] initWithZero];
    self.value = [[Formula alloc] initWithZero];
}

#pragma mark - Resources
- (NSInteger)getRequiredResources
{
    return kBluetoothArduino|[self.pin getRequiredResources]|[self.value getRequiredResources];
}
@end
