//
//  AppDelegate.m
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"



static void displayConfigurationChanged(CGDirectDisplayID display, CGDisplayChangeSummaryFlags flags, void *userInfo) {
    // Reload display configuration
    MainController *menu = (__bridge MainController *)userInfo;
    [menu loadDisplays];
}



@interface AppDelegate () {
     NSStatusItem *_statusItem;
}

@property IBOutlet MainController *mainController;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Register defaults
    NSMutableDictionary *defaults = [NSMutableDictionary new];
    defaults[@"MaxBrightnessValue"] = @0;
    defaults[@"BrightnessMapSlider0"] = @0;
    defaults[@"BrightnessMapSlider1"] = @10;
    defaults[@"BrightnessMapSlider2"] = @20;
    defaults[@"BrightnessMapSlider3"] = @30;
    defaults[@"BrightnessMapSlider4"] = @40;
    defaults[@"BrightnessMapSlider5"] = @50;
    defaults[@"BrightnessMapSlider6"] = @60;
    defaults[@"BrightnessMapSlider7"] = @70;
    defaults[@"BrightnessMapSlider8"] = @80;
    defaults[@"BrightnessMapSlider9"] = @90;
    defaults[@"BrightnessMapSlider10"] = @100;
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

    // Hook to dispaly configuration events
    CGDisplayRegisterReconfigurationCallback(displayConfigurationChanged, (__bridge void *)(self.mainController));

    // Prepare status bar item
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleShortVersionString"];

    self->_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self->_statusItem.button.image = [NSImage imageNamed:@"Icon"];
    self->_statusItem.toolTip = [NSString stringWithFormat:@"Brisync %@", version];
    self->_statusItem.menu = self.mainController.statusMenu;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    CGDisplayRemoveReconfigurationCallback(displayConfigurationChanged, (__bridge void *)(self.mainController));
}


@end
