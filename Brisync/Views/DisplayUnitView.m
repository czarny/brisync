//
//  DisplayUnitView.m
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import "DisplayUnitView.h"
#import "DisplayUnitXib.h"



@implementation DisplayUnitView

- (IBAction)onMapClick:(id)sender {
    DisplaySettingsView *settings = [DisplayUnitXib initDisplaySettingsView];
    settings.parent = self;
    settings.display = self.display;
    settings.brightnessLevel.doubleValue = self.builtInDisplay.brightness;

    settings.slider0.intValue = [self.display.brightnessMap[0] intValue];
    settings.slider1.intValue = [self.display.brightnessMap[1] intValue];
    settings.slider2.intValue = [self.display.brightnessMap[2] intValue];
    settings.slider3.intValue = [self.display.brightnessMap[3] intValue];
    settings.slider4.intValue = [self.display.brightnessMap[4] intValue];
    settings.slider5.intValue = [self.display.brightnessMap[5] intValue];
    settings.slider6.intValue = [self.display.brightnessMap[6] intValue];
    settings.slider7.intValue = [self.display.brightnessMap[7] intValue];
    settings.slider8.intValue = [self.display.brightnessMap[8] intValue];
    settings.slider9.intValue = [self.display.brightnessMap[9] intValue];
    settings.slider10.intValue = [self.display.brightnessMap[10] intValue];

    [NSApp activateIgnoringOtherApps: YES];
    [settings center];
    [settings makeKeyAndOrderFront:sender];
}

@end
