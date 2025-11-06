//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//
#import <CoreGraphics/CoreGraphics.h>

// Declare the private DisplayServices function
extern CGError DisplayServicesGetBrightness(CGDirectDisplayID display, float *brightness);
extern CGError DisplayServicesSetBrightness(CGDirectDisplayID display, float brightness);
