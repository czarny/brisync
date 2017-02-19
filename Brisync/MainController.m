//
//  MainController.m
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import "MainController.h"
#import "DisplayManager.h"



@interface MainController () {
    DisplayManager *_displayManager;
    NSInteger _lastBrightness;
}

@end


@implementation MainController

-(void)setStatusMenu:(NSMenu *)statusMenu {
    self->_statusMenu = statusMenu;
    [self loadDisplays];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        // Schedule brightness checking
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(onBrightnessCheck:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];   // Run in common mode to fire when status item is open
    }

    return self;
}

#pragma mark Events

- (IBAction)onQuit:(id)sender {
    exit(0);
}


- (void)onBrightnessCheck:(NSTimer *)sender {
    float brightness = [self->_displayManager getDisplayBrightness:self->_displayManager.builtinDisplay];
    if(brightness != self->_lastBrightness) {
        for(NSNumber *display_id in self->_displayManager.externalDisplays) {
            CGDirectDisplayID display = [display_id intValue];
            [self->_displayManager setBrightness:brightness forDisplay:display];
        }
    }

    self->_lastBrightness = brightness;
}


#pragma mark Private
- (void)loadDisplays {
    self->_displayManager = [DisplayManager new];
    self->_lastBrightness = 0;  // Force brightness sync
}

@end
