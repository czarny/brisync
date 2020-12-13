//
//  DisplayManager.m
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import "DisplayManager.h"
#import "DDC.h"



static const int kMaxDisplays = 16;


NSString *EDIDString(char *string) {
    NSString *temp = [[NSString alloc] initWithBytes:string length:13 encoding:NSASCIIStringEncoding];
    return ([temp rangeOfString:@"\n"].location != NSNotFound) ? [[temp componentsSeparatedByString:@"\n"] objectAtIndex:0] : temp;
}


NSString *DisplayGetDescription(CGDirectDisplayID display, UInt8 type) {
    NSString *result = @"Unknown display";
    struct EDID edid = {};

    if (EDIDTest(display, &edid)) {
        for (union descriptor *des = edid.descriptors; des < edid.descriptors + sizeof(edid.descriptors); des++) {
            if(des->text.type == type) {
                result = EDIDString(des->text.data);
                break;
            }
        }
    }

    return result;
}



@implementation DisplayManager

- (instancetype)init {
    self = [super init];
    if(self) {
        NSMutableArray *external_displays = [NSMutableArray new];

        // Get displays
        CGDirectDisplayID displays[kMaxDisplays];
        CGDisplayCount count;
        CGGetActiveDisplayList(kMaxDisplays, displays, &count);
        for(int i = 0; i < count; i++) {
            CGDirectDisplayID displayID = displays[i];
            Display *display = [[Display alloc] initWithID:displayID andManager:self];

            if(display.isBuiltIn) {
                self->_builtinDisplay = display;
            }
            else {
                [external_displays addObject:display];
            }
        }

        self->_externalDisplays = [external_displays copy];
    }

    return self;
}


- (NSString *)getDisplayName:(CGDirectDisplayID)display {
    NSString *result = DisplayGetDescription(display, 0xFC);
    return result;
}


- (NSString *)getDisplaySerial:(CGDirectDisplayID)display {
    NSString *result = DisplayGetDescription(display, 0xFF);
    return result;
}


- (BOOL)getIsBuiltIn:(CGDirectDisplayID)display {
    BOOL result = CGDisplayIsBuiltin(display);
    return result;
}


- (NSInteger)getDisplayBrightness:(CGDirectDisplayID)display {
    NSInteger result = 0;
    float brightness = 0;

    io_service_t service = CGDisplayIOServicePort(display);
    IOReturn err = IODisplayGetFloatParameter(service, kNilOptions, CFSTR(kIODisplayBrightnessKey), &brightness);
    if (err == kIOReturnSuccess) {
        result = brightness * 100;
    }

    return result;
}


- (void)setBrightness:(NSInteger)brightness forDisplay:(CGDirectDisplayID)display {
    struct DDCWriteCommand command;
    command.control_id = BRIGHTNESS;
    command.new_value = brightness;

    if (!DDCWrite(display, &command)){
        NSLog(@"E: Failed to send DDC command!");
    }
    
}

@end
