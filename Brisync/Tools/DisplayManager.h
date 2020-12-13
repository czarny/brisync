//
//  DisplayManager.h
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Display.h"


@interface DisplayManager : NSObject

@property(nonatomic, readonly) Display *builtInDisplay;
@property(nonatomic, readonly) NSArray<Display *> *externalDisplays;

- (NSString *)getDisplayName:(CGDirectDisplayID)display;
- (NSString *)getDisplaySerial:(CGDirectDisplayID)display;
- (BOOL)getIsBuiltIn:(CGDirectDisplayID)display;
- (NSInteger)getDisplayBrightness:(CGDirectDisplayID)display;
- (void)setBrightness:(NSInteger)brightness forDisplay:(CGDirectDisplayID)display;

@end
