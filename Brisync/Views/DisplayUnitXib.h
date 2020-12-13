//
//  DisplayUnit.h
//  Brisync
//
//  Created by Krzysztof Czarnota on 11/12/2020.
//  Copyright © 2020 czarny. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DisplayUnitView.h"
#import "DisplaySettingsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DisplayUnitXib : NSObject

@property (nonatomic, readwrite) IBOutlet DisplayUnitView *displayUnitView;
@property (nonatomic, readwrite) IBOutlet DisplaySettingsView *settingsPanel;

+ (DisplayUnitView *)initDisplayUnitView;
+ (DisplaySettingsView *)initDisplaySettingsView;

@end

NS_ASSUME_NONNULL_END
