//
//  Display.h
//  Brisync
//
//  Created by Krzysztof Czarnota on 11/12/2020.
//  Copyright © 2020 czarny. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class DisplayManager;


@interface Display : NSObject

@property(nonatomic, assign) CGDirectDisplayID ID;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *serial;
@property(nonatomic, readonly) BOOL isBuiltIn;
@property(nonatomic, assign) NSInteger brightness;
@property(nonatomic, assign) NSArray *brightnessMap;
@property(nonatomic, assign) NSInteger maxBrightnessValue;


- (instancetype)initWithID:(CGDirectDisplayID)ID andManager:(DisplayManager *)manager;
- (NSUInteger)adjustToLevel:(NSUInteger)brightness;

@end

NS_ASSUME_NONNULL_END
