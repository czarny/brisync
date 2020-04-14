//
//  PreferencesController.m
//  Brisync
//
//  Created by Krzysztof Czarnota on 14/04/2020.
//  Copyright © 2020 czarny. All rights reserved.
//

#import "PreferencesController.h"

@implementation PreferencesController

- (IBAction)onMapValueChanged:(NSSlider *)slider {

    if(slider == self.slider10) {
        self.slider9.intValue = (self.slider10.intValue + self.slider8.intValue) / 2;
    }

    if(slider == self.slider9) {
        self.slider8.intValue = (self.slider9.intValue + self.slider7.intValue) / 2;
        self.slider10.intValue = (self.slider9.intValue + 100) / 2;
    }

    if(slider == self.slider8) {
        self.slider7.intValue = (self.slider8.intValue + self.slider6.intValue) / 2;
        self.slider9.intValue = (self.slider8.intValue + self.slider10.intValue) / 2;
    }

    if(slider == self.slider7) {
        self.slider6.intValue = (self.slider7.intValue + self.slider5.intValue) / 2;
        self.slider8.intValue = (self.slider7.intValue + self.slider9.intValue) / 2;
    }

    if(slider == self.slider6) {
        self.slider5.intValue = (self.slider6.intValue + self.slider4.intValue) / 2;
        self.slider7.intValue = (self.slider6.intValue + self.slider8.intValue) / 2;
    }

    if(slider == self.slider5) {
        self.slider4.intValue = (self.slider5.intValue + self.slider3.intValue) / 2;
        self.slider6.intValue = (self.slider5.intValue + self.slider7.intValue) / 2;
    }

    if(slider == self.slider4) {
        self.slider3.intValue = (self.slider4.intValue + self.slider2.intValue) / 2;
        self.slider5.intValue = (self.slider4.intValue + self.slider6.intValue) / 2;
    }

    if(slider == self.slider3) {
        self.slider2.intValue = (self.slider3.intValue + self.slider1.intValue) / 2;
        self.slider4.intValue = (self.slider3.intValue + self.slider5.intValue) / 2;
    }

    if(slider == self.slider2) {
        self.slider1.intValue = (self.slider2.intValue + self.slider0.intValue) / 2;
        self.slider3.intValue = (self.slider2.intValue + self.slider4.intValue) / 2;
    }

    if(slider == self.slider1) {
        self.slider0.intValue = (self.slider1.intValue + 0)/ 2;
        self.slider2.intValue = (self.slider1.intValue + self.slider3.intValue) / 2;
    }

    if(slider == self.slider0) {
        self.slider1.intValue = (self.slider0.intValue + self.slider2.intValue) / 2;
    }
}


@end
