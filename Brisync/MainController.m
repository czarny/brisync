//
//  MainController.m
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import "MainController.h"
#import "DisplayManager.h"
#import "DisplayUnitXib.h"
#import <EventKit/EventKit.h>

@import Carbon;



@interface MainController () {
    NSMutableDictionary *_displayMenuItems;
    NSInteger _lastBrightness;
}

@property(readonly) DisplayManager *displayManager;

@end


@implementation MainController

-(void)setStatusMenu:(NSMenu *)statusMenu {
    self->_statusMenu = statusMenu;
    [self loadDisplays];
}


- (instancetype)init {
    self = [super init];
    if(self) {
        [self initBrightnessCheckTimer];
    }

    return self;
}

- (void)initBrightnessCheckTimer {
    // Schedule brightness checking
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(onBrightnessCheck:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];   // Run in common mode to fire when status item is open
}

#pragma mark Events

- (IBAction)onQuit:(id)sender {
    exit(0);
}

- (IBAction)onAbout:(id)sender {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:sender];
}


- (void)onBrightnessCheck:(NSTimer *)sender {
    NSInteger brightness = self.displayManager.builtInDisplay.brightness;

    if(brightness != self->_lastBrightness) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BuildInBrigthnessChange" object:@(brightness)];
        
        for(Display *display in self.displayManager.externalDisplays) {
            // Adjust display brightness
            NSUInteger procent = [display adjustToLevel:brightness];
            display.brightness = procent;
            // Update view
            DisplayUnitView *unit = (DisplayUnitView *)[self->_displayMenuItems[@(display.ID)] view];
            unit.brigthness.stringValue = [NSString stringWithFormat:@"%d%%", (int)procent];
        }
    }

    self->_lastBrightness = brightness;
}





#pragma mark Public

- (void)loadDisplays {
    // Clean up
    for(NSMenuItem *item in self->_displayMenuItems.allValues) {
        [self.statusMenu removeItem:item];
    }

    self->_displayMenuItems = [NSMutableDictionary new];
    self->_displayManager = [DisplayManager new];

    for(Display *display in self.displayManager.externalDisplays) {
        DisplayUnitView *unit = [DisplayUnitXib initDisplayUnitView];
        unit.name.stringValue = display.name;
        unit.display = display;
        unit.builtInDisplay = self.displayManager.builtInDisplay;

        NSMenuItem *menu_item = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
        menu_item.view = unit;
        [self->_statusMenu insertItem:menu_item atIndex:0];

        self->_displayMenuItems[@(display.ID)] = menu_item;
    }

    self->_lastBrightness = 0;  // Force brightness sync
}

@end
