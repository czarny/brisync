//
//  MainController.m
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import "MainController.h"
#import "DisplayManager.h"
#import "DisplayUnitView.h"



@interface MainController () {
    DisplayManager *_displayManager;
    NSMutableDictionary *_displayMenuItems;
    NSMutableDictionary *_brightnessFactor;

    NSInteger _lastBrightness;
}

@property(readonly) NSInteger maxBrightnessValue;

@end


@implementation MainController

-(void)setStatusMenu:(NSMenu *)statusMenu {
    self->_statusMenu = statusMenu;
    [self loadDisplays];
}


- (NSInteger)maxBrightnessValue {
    NSInteger options[2] = { 100, 255 };
    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"MaxBrightnessValue"];
    return options[index];
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

- (IBAction)onPreferences:(id)sender {
    [NSApp activateIgnoringOtherApps: YES];
    [self.preferencesPanel center];
    [self.preferencesPanel makeKeyAndOrderFront:sender];
}


- (IBAction)onAbout:(id)sender {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:sender];
}


- (void)onBrightnessCheck:(NSTimer *)sender {
    NSInteger brightness = [self->_displayManager getDisplayBrightness:self->_displayManager.builtinDisplay];

    if(brightness != self->_lastBrightness) {
        for(NSNumber *display_id in self->_displayManager.externalDisplays) {
            CGDirectDisplayID display = [display_id intValue];
            CGFloat factor = [self->_brightnessFactor[display_id] floatValue];

            NSInteger procent = MIN((int)(brightness * factor), 100);
            NSInteger new_brightness = (procent * self.maxBrightnessValue) / 100;
            [self->_displayManager setBrightness:new_brightness forDisplay:display];

            DisplayUnitView *unit = (DisplayUnitView *)[self->_displayMenuItems[display_id] view];
            [unit.slider setDoubleValue:procent];
        }
    }

    self->_lastBrightness = brightness;
}


- (void)onSliderValueChanged:(NSSlider *)slider {
    CGDirectDisplayID display = (CGDirectDisplayID)slider.tag;
    NSInteger new_brightness = (slider.intValue * self.maxBrightnessValue) / 100;   // Scaled value for display
    [self->_displayManager setBrightness:new_brightness forDisplay:display];

    // Calc factor
    CGFloat factor = (CGFloat)slider.intValue / (CGFloat)self->_lastBrightness;
    self->_brightnessFactor[@(slider.tag)] = @(factor);

    // Save factor in
    NSString *serial = [self->_displayManager getDisplaySerial:display];
    if(serial) {
        NSMutableDictionary *settings = [self getDisplaySettings:serial];
        settings[@"brightness_factor"] = @(factor);
        [[NSUserDefaults standardUserDefaults] setObject:settings forKey:serial];
    }
}


#pragma mark Public

- (void)loadDisplays {
    // Clean up
    for(NSMenuItem *item in self->_displayMenuItems.allValues) {
        [self->_statusMenu removeItem:item];
    }

    self->_displayMenuItems = [NSMutableDictionary new];
    self->_brightnessFactor = [NSMutableDictionary new];
    self->_displayManager = [DisplayManager new];

    for(NSNumber *display_id in self->_displayManager.externalDisplays) {
        CGDirectDisplayID display = [display_id intValue];

        DisplayUnitView *unit = [self createDisplayUnitView];
        unit.name.stringValue = [self->_displayManager getDisplayName:display];
        unit.slider.tag = display;

        NSMenuItem *menu_item = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
        menu_item.view = unit;
        [self->_statusMenu insertItem:menu_item atIndex:0];

        self->_displayMenuItems[display_id] = menu_item;
        self->_brightnessFactor[display_id] = @1.0;

        NSString *serial = [self->_displayManager getDisplaySerial:display];
        if(serial) {
            // Restore brightness factor
            NSDictionary *settings = [self getDisplaySettings:serial];
            if([settings objectForKey:@"brightness_factor"]) {
                self->_brightnessFactor[display_id] = settings[@"brightness_factor"];
            }
        }
    }

    self->_lastBrightness = 0;  // Force brightness sync
}


#pragma mark Private

- (DisplayUnitView *)createDisplayUnitView {
    NSArray *o;
    [[NSBundle mainBundle] loadNibNamed:@"DisplayUnit" owner:nil topLevelObjects:&o];
    DisplayUnitView *result = [o.firstObject isKindOfClass:[DisplayUnitView class]]? o.firstObject : o.lastObject;
    [result.slider setTarget:self];
    [result.slider setAction:@selector(onSliderValueChanged:)];

    return result;
}

- (NSMutableDictionary *)getDisplaySettings:(NSString *)serial {
    NSMutableDictionary *result = [NSMutableDictionary new];
    NSDictionary *settings = [[NSUserDefaults standardUserDefaults] objectForKey:serial];
    [result addEntriesFromDictionary:settings];

    return result;
}


@end
