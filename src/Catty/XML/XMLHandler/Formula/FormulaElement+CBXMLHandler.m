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

#import "FormulaElement+CBXMLHandler.h"
#import "CBXMLValidator.h"
#import "GDataXMLElement+CustomExtensions.h"
#import "CBXMLParserContext.h"
#import "CBXMLSerializerContext.h"
#import "SpriteObject.h"
#import "Pocket_Code-Swift.h"

#define kAdditionalChildFormulaElementTag @"org.catrobat.catroid.formulaeditor.FormulaElement"

@implementation FormulaElement (CBXMLHandler)

+ (instancetype)parseFromElement:(GDataXMLElement*)xmlElement withContext:(CBXMLParserContext*)context
{
    GDataXMLElement *typeElement = [xmlElement childWithElementName:@"type"];
    [XMLError exceptionIfNil:xmlElement message:@"No type element found..."];
    NSString *type = [typeElement stringValue];
    
    if ([CollisionFunction.tag isEqualToString:type]) {
        return [[CollisionFunction class] parseFromElement:xmlElement withContext:context];
    }
    
    GDataXMLElement *valueElement = [xmlElement childWithElementName:@"value"];
    NSString *stringValue = [valueElement stringValue];
    
    if ([type isEqualToString:@"SENSOR"]) {
        if ([stringValue isEqualToString:@"FACE_X_POSITION"]) {
            stringValue = @"FACE_X";
        } else if ([stringValue isEqualToString:@"FACE_Y_POSITION"]) {
            stringValue = @"FACE_Y";
        }
    }
    
    FormulaElement *formulaTree = [[FormulaElement alloc] initWithType:type
                                                                 value:stringValue
                                                             leftChild:nil
                                                            rightChild:nil
                                                                parent:nil];
    
    GDataXMLElement *rightChildElement = [xmlElement childWithElementName:@"rightChild"];
    if (rightChildElement) {
        FormulaElement *rightChildFormula = [context parseFromElement:rightChildElement withClass:[self class]];
        rightChildFormula.parent = formulaTree;
        formulaTree.rightChild = rightChildFormula;
    }
    
    GDataXMLElement *leftChildElement = [xmlElement childWithElementName:@"leftChild"];
    if (leftChildElement) {
        FormulaElement *leftChildFormula = [context parseFromElement:leftChildElement withClass:[self class]];
        leftChildFormula.parent = formulaTree;
        formulaTree.leftChild = leftChildFormula;
    }
    
    GDataXMLElement *additionalChildrenContainer = [xmlElement childWithElementName:@"additionalChildren"];
    if (additionalChildrenContainer) {
        NSMutableArray<FormulaElement*> *additionalChildren = [NSMutableArray new];
        NSArray<GDataXMLElement*> *additionaChildrenElements = [additionalChildrenContainer childrenWithElementName:kAdditionalChildFormulaElementTag];
        
        for (GDataXMLElement *additionalChild in additionaChildrenElements) {
            FormulaElement *additionalChildFormula = [context parseFromElement:additionalChild withClass:[self class]];
            additionalChildFormula.parent = formulaTree;
            
            [additionalChildren addObject:additionalChildFormula];
        }
        formulaTree.additionalChildren = additionalChildren;
    }
    
    return formulaTree;
}

- (GDataXMLElement*)xmlElementWithContext:(CBXMLSerializerContext*)context
{
    GDataXMLElement *formulaElement = [GDataXMLElement elementWithName:@"formulaElement" context:context];
    
    if (FUNCTION == self.type && [CollisionFunction.tag isEqualToString:self.value]) {
        return [[CollisionFunction class] xmlElementForFormula:self withContext:context];
    }
    
    if (self.leftChild != nil) {
        GDataXMLElement *leftChild = [GDataXMLElement elementWithName:@"leftChild" context:context];
        for(GDataXMLNode *node in [self.leftChild xmlElementWithContext:context].children) {
            [leftChild addChild:node context:context];
        }
        [formulaElement addChild:leftChild context:context];
    }
    
    if (self.rightChild != nil) {
        GDataXMLElement *rightChild = [GDataXMLElement elementWithName:@"rightChild" context:context];
        for(GDataXMLNode *node in [self.rightChild xmlElementWithContext:context].children) {
            [rightChild addChild:node context:context];
        }
        [formulaElement addChild:rightChild context:context];
    }
    
    if (self.additionalChildren != nil && self.additionalChildren.count > 0) {
        GDataXMLElement *additionalChildrenContainer = [GDataXMLElement elementWithName:@"additionalChildren" context:context];
        for (FormulaElement *additionalChildFormula in self.additionalChildren) {
            
            GDataXMLElement *additionalChildElement = [GDataXMLElement elementWithName:kAdditionalChildFormulaElementTag context:context];
            for(GDataXMLNode *node in [additionalChildFormula xmlElementWithContext:context].children) {
                [additionalChildElement addChild:node context:context];
            }
            [additionalChildrenContainer addChild:additionalChildElement context:context];
        }
        [formulaElement addChild:additionalChildrenContainer context:context];
    }
    
    GDataXMLElement *type = [GDataXMLElement elementWithName:@"type" stringValue:[self stringForElementType:self.type] context:context];
    [formulaElement addChild:type context:context];
    if (self.value) {
        GDataXMLElement *value = [GDataXMLElement elementWithName:@"value" stringValue:self.value context:context];
        [formulaElement addChild:value context:context];
    }
    
    return formulaElement;
}

@end
