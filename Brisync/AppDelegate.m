//
//  AppDelegate.m
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"



@interface AppDelegate () {
     NSStatusItem *_statusItem;
}

@property IBOutlet MainController *mainController;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self->_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self->_statusItem.button.image = [NSImage imageNamed:@"Icon"];
    self->_statusItem.toolTip = @"Brisync";
    self->_statusItem.menu = self.mainController.statusMenu;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
