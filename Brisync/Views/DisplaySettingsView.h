//
//  DisplaySettingsView.h
//  Brisync
//
//  Created by Krzysztof Czarnota on 11/12/2020.
//  Copyright © 2020 czarny. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Display.h"

NS_ASSUME_NONNULL_BEGIN

@interface DisplaySettingsView : NSPanel

@property (nonatomic, readwrite) IBOutlet NSTextField *name;
@property (nonatomic, readwrite) IBOutlet NSSlider *slider0;
@property (nonatomic, readwrite) IBOutlet NSSlider *slider1;
@property (nonatomic, readwrite) IBOutlet NSSlider *slider2;
@property (nonatomic, readwrite) IBOutlet NSSlider *slider3;
@property (nonatomic, readwrite) IBOutlet NSSlider *slider4;
@property (nonatomic, readwrite) IBOutlet NSSlider *slider5;
@property (nonatomic, readwrite) IBOutlet NSSlider *slider6;
@property (nonatomic, readwrite) IBOutlet NSSlider *slider7;
@property (nonatomic, readwrite) IBOutlet NSSlider *slider8;
@property (nonatomic, readwrite) IBOutlet NSSlider *slider9;
@property (nonatomic, readwrite) IBOutlet NSSlider *slider10;
@property (nonatomic, readwrite) IBOutlet NSSlider *sliderBrightness;

@property (nonatomic, strong) Display *display;

@end

NS_ASSUME_NONNULL_END
