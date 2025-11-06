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
    NSDictionary *settings = @{@"": @{@"MaxBrightnessValue": @100, @"BrightnessMap": @[@0, @10, @20, @30, @40, @50, @60, @70, @80 , @90, @100]}};
    NSMutableDictionary *defaults = [NSMutableDictionary new];
    defaults[@"DisplaySettings"] = settings;
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

    // Hook to dispaly configuration events
    CGDisplayRegisterReconfigurationCallback(displayConfigurationChanged, (__bridge void *)(self.mainController));

    // Prepare status bar item
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleShortVersionString"];

    self->_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self->_statusItem.button.image = [NSImage imageNamed:@"Icon"];
    self->_statusItem.button.toolTip = [NSString stringWithFormat:@"Brisync %@", version];
    self->_statusItem.menu = self.mainController.statusMenu;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    CGDisplayRemoveReconfigurationCallback(displayConfigurationChanged, (__bridge void *)(self.mainController));
}


@end
