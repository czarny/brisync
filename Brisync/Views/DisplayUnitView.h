//
//  DisplayUnitView.h
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Brisync-Swift.h"


@interface DisplayUnitView : NSView

@property (nonatomic, readwrite) IBOutlet NSTextField *name;
@property (nonatomic, readwrite) IBOutlet NSTextField *brigthness;


@property (nonatomic, strong) Display *display;
@property (nonatomic, strong) Display *mainDisplay;

@end
