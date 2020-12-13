//
//  Display.m
//  Brisync
//
//  Created by Krzysztof Czarnota on 11/12/2020.
//  Copyright © 2020 czarny. All rights reserved.
//

#import "Display.h"
#import "DisplayManager.h"

@interface Display()

@property(nonatomic, weak) DisplayManager *manager;

@property(nonatomic, readonly) NSDictionary *settings;

@end    

@implementation Display

- (NSDictionary *)settings {
    NSDictionary *defaults = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"DisplaySettings"];
    NSDictionary *settings = self.serial && defaults[self.serial] ? defaults[self.serial] : defaults[@""];
    return settings;
}

- (void)setSettings:(NSDictionary *)settings {
    NSMutableDictionary *defaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"DisplaySettings"] mutableCopy];
    defaults[self.serial ? self.serial : @""] = settings;
    [[NSUserDefaults standardUserDefaults] setObject:defaults forKey:@"DisplaySettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (instancetype)initWithID:(CGDirectDisplayID)ID andManager:(DisplayManager *)manager {
    self = [super init];
    if(self) {
        self.ID = ID;
        self.manager = manager;
        self->_name = [manager getDisplayName:self.ID];
        self->_serial = [manager getDisplaySerial:self.ID];
        self->_isBuiltIn = [manager getIsBuiltIn:self.ID];
    }

    return self;
}


- (NSInteger)brightness {
    NSInteger b = [self.manager getDisplayBrightness:self.ID];
    return b;
}


- (void)setBrightness:(NSInteger)brightness {
    [self.manager setBrightness:brightness forDisplay:self.ID];
}


- (NSArray *)brightnessMap {
    NSArray *result = self.settings[@"BrightnessMap"];
    return result;
}

- (void)setBrightnessMap:(NSArray *)brightnessMap {
    NSMutableDictionary *s = [self.settings mutableCopy];
    s[@"BrightnessMap"] = brightnessMap;
    self.settings = s;
}


- (NSInteger)maxBrightnessValue {
    NSInteger result = [self.settings[@"MaxBrightnessValue"] intValue];
    return result;
}


- (void)setMaxBrightnessValue:(NSInteger)maxBrightnessValue {
    NSMutableDictionary *s = [self.settings mutableCopy];
    s[@"MaxBrightnessValue"] = @(maxBrightnessValue);
    self.settings = s;

}

@end
