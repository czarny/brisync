//
//  DisplayUnitView.m
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import "DisplayUnitView.h"



@implementation DisplayUnitView

- (void)setDisplay:(Display *)display {
    self->_display = display;
    self.settingsPanel.display = display;

    self.name.stringValue = display.name;
    self.settingsPanel.name.stringValue = display.name;
}

- (IBAction)onMapClick:(id)sender {
    self.settingsPanel.slider0.intValue = [self.display.brightnessMap[0] intValue];
    self.settingsPanel.slider1.intValue = [self.display.brightnessMap[1] intValue];
    self.settingsPanel.slider2.intValue = [self.display.brightnessMap[2] intValue];
    self.settingsPanel.slider3.intValue = [self.display.brightnessMap[3] intValue];
    self.settingsPanel.slider4.intValue = [self.display.brightnessMap[4] intValue];
    self.settingsPanel.slider5.intValue = [self.display.brightnessMap[5] intValue];
    self.settingsPanel.slider6.intValue = [self.display.brightnessMap[6] intValue];
    self.settingsPanel.slider7.intValue = [self.display.brightnessMap[7] intValue];
    self.settingsPanel.slider8.intValue = [self.display.brightnessMap[8] intValue];
    self.settingsPanel.slider9.intValue = [self.display.brightnessMap[9] intValue];
    self.settingsPanel.slider10.intValue = [self.display.brightnessMap[10] intValue];



    [NSApp activateIgnoringOtherApps: YES];

    [self.settingsPanel center];
    [self.settingsPanel makeKeyAndOrderFront:sender];
}


- (IBAction)onSliderValueChanged:(NSSlider *)slider {
    NSInteger old_brightness = self.display.brightness;
    NSInteger new_brightness = (slider.intValue * self.display.maxBrightnessValue) / 100;   // Scaled value for display
    self.display.brightness = new_brightness;

//    // Update the map
//    NSUInteger start = old_brightness / 10;
//    NSInteger y = new_brightness % 10;
//    NSInteger x0 = [display.brightnessMap[scope] integerValue];
//    NSInteger x1 = [display.brightnessMap[scope+1] integerValue];
//    CGFloat a = (x1 - x0) / 10;
//    NSUInteger map_value = a * x + x0;
}
@end

