//
//  DisplayManager.h
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DisplayManager : NSObject

@property(nonatomic, readonly) CGDirectDisplayID builtinDisplay;
@property(nonatomic, readonly) NSArray *externalDisplays;

- (NSString *)getDisplayName:(CGDirectDisplayID)display;
- (NSString *)getDisplaySerial:(CGDirectDisplayID)display;
- (NSInteger)getDisplayBrightness:(CGDirectDisplayID)display;
- (void)setBrightness:(NSInteger)brightness forDisplay:(CGDirectDisplayID)display;

@end
