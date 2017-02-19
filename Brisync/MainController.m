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


- (void)onSliderValueChanged:(NSSlider *)slider {
    CGDirectDisplayID display = (CGDirectDisplayID)slider.tag;
    [self->_displayManager setBrightness:slider.intValue forDisplay:display];

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

        DisplayUnitView *unit = [self createDispalyUnitView];
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

- (DisplayUnitView *)createDispalyUnitView {
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
