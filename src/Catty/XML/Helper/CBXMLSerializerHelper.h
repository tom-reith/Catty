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

#import <Foundation/Foundation.h>

@class Sound;
@class Look;
@class CBXMLPositionStack;
@class SpriteObject;
@protocol BrickProtocol;

@interface CBXMLSerializerHelper : NSObject

+ (NSUInteger)indexOfElement:(id)element inArray:(NSArray*)array;
+ (NSString*)relativeXPathToSound:(Sound*)sound inSoundList:(NSArray*)soundList withDepth:(NSInteger)depth;
+ (NSString*)relativeXPathToLook:(Look*)look inLookList:(NSArray*)lookList withDepth:(NSInteger)depth;
+ (NSString*)relativeXPathToBackground:(Look*)look forBackgroundObject:(SpriteObject*)backgroundObject withDepth:(NSInteger)depth;
+ (NSString*)relativeXPathFromSourcePositionStack:(CBXMLPositionStack*)sourcePositionStack
                       toDestinationPositionStack:(CBXMLPositionStack*)destinationPositionStack;
+ (NSInteger)getDepthOfResource:(id<BrickProtocol>)scriptOrBrick forSpriteObject:(SpriteObject*)spriteObject;

@end
