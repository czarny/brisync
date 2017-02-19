//
//  MainController.h
//  Brisync
//
//  Created by Krzysztof Czarnota on 19.02.2017.
//  Copyright © 2017 czarny. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface MainController : NSObject

@property (nonatomic, readwrite) IBOutlet NSMenu *statusMenu;

- (void)loadDisplays;

@end
