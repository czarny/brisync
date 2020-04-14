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
#import <EventKit/EventKit.h>

@import Carbon;



@interface MainController () {
    NSMutableDictionary *_displayMenuItems;
    NSMutableDictionary *_brightnessFactor;

    NSInteger _lastBrightness;
}

@property(readonly) DisplayManager *displayManager;
@property(readonly) NSInteger maxBrightnessValue;
@property(readonly) NSArray *brightnessMap;

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


- (NSArray *)brightnessMap {
    NSMutableArray *result = [NSMutableArray new];
    for(int i = 0; i< 11; i++) {
        NSString *key = [NSString stringWithFormat:@"BrightnessMapSlider%d", i];
        NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        [result addObject:value];
    }

    return result;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [self initBrightnessCheckTimer];
        [self registerHotKeys];
    }

    return self;
}

- (void)initBrightnessCheckTimer {
    // Schedule brightness checking
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(onBrightnessCheck:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];   // Run in common mode to fire when status item is open
}


- (void)registerHotKeys {
    EventHotKeyRef gMyHotKeyRef;
    EventHotKeyID gMyHotKeyID;
    EventTypeSpec eventType;
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;

    InstallApplicationEventHandler(&OnHotKeyEvent, 1, &eventType, (void *)CFBridgingRetain(self), NULL);

    gMyHotKeyID.signature='htk1';
    gMyHotKeyID.id=1;
    RegisterEventHotKey(kVK_F1, shiftKey+controlKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);

    gMyHotKeyID.signature='htk2';
    gMyHotKeyID.id=2;
    RegisterEventHotKey(kVK_F2, shiftKey+controlKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
}


OSStatus OnHotKeyEvent(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData) {
    MainController *_self = (__bridge MainController *)userData;
    EventHotKeyID hk_com;
    GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hk_com), NULL, &hk_com);

    NSInteger change = 0;
    if(hk_com.id == 1) {
        change = -5;
    }
    else if(hk_com.id == 2) {
        change = 5;
    }

    for(NSNumber *display_id in _self.displayManager.externalDisplays) {
        DisplayUnitView *unit = (DisplayUnitView *)[_self->_displayMenuItems[display_id] view];
        unit.slider.doubleValue = MIN(100, MAX(unit.slider.doubleValue + change, 0));
        [_self onSliderValueChanged:unit.slider];
    }

    return noErr;
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
    NSArray *brightness_map = self.brightnessMap;

    if(brightness != self->_lastBrightness) {
        for(NSNumber *display_id in self->_displayManager.externalDisplays) {
            NSUInteger scope = brightness / 10;
            NSInteger x = brightness % 10;
            NSUInteger x0 = [brightness_map[scope] integerValue];
            NSUInteger x1 = [brightness_map[scope+1] integerValue];
            CGFloat a = (x1 - x0) / 10;
            NSUInteger map_value = a * x + x0;

            CGDirectDisplayID display = [display_id intValue];
            CGFloat factor = [self->_brightnessFactor[display_id] floatValue];

            NSInteger procent = MIN((int)(map_value * factor), 100);
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
