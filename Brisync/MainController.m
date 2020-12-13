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

    for(Display *display in _self.displayManager.externalDisplays) {
        DisplayUnitView *unit = (DisplayUnitView *)[_self->_displayMenuItems[@(display.ID)] view];
        unit.slider.doubleValue = MIN(100, MAX(unit.slider.doubleValue + change, 0));
      // TODO:  [_self onSliderValueChanged:unit.slider];
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
    NSInteger brightness = self.displayManager.builtinDisplay.brightness;

    if(brightness != self->_lastBrightness) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BuildInBrigthnessChange" object:@(brightness)];
        
        for(Display *display in self.displayManager.externalDisplays) {
            // Adjust display brightness
            NSUInteger procent = [display adjustToLevel:brightness];

            // Update view
            DisplayUnitView *unit = (DisplayUnitView *)[self->_displayMenuItems[@(display.ID)] view];
            [unit.slider setDoubleValue:procent];
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
        DisplayUnitView *unit = [self createDisplayUnitView];
        unit.display = display;

        NSMenuItem *menu_item = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
        menu_item.view = unit;
        [self->_statusMenu insertItem:menu_item atIndex:0];

        self->_displayMenuItems[@(display.ID)] = menu_item;
    }

    self->_lastBrightness = 0;  // Force brightness sync
}


#pragma mark Private

- (DisplayUnitView *)createDisplayUnitView {
    DisplayUnitXib *xib = [DisplayUnitXib new];
    [[NSBundle mainBundle] loadNibNamed:@"DisplayUnit" owner:xib topLevelObjects:nil];
    DisplayUnitView *result = xib.displayUnitView;
    return result;
}

@end
