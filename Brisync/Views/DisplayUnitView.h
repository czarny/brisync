//
//  DisplayUnitView.h
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DisplayUnitView : NSView

@property (nonatomic, readwrite) IBOutlet NSTextField *name;
@property (nonatomic, readwrite) IBOutlet NSSlider *slider;

@end
