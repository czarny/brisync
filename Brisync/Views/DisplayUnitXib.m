//
//  DisplayUnit.m
//  Brisync
//
//  Created by Krzysztof Czarnota on 11/12/2020.
//  Copyright © 2020 czarny. All rights reserved.
//

#import "DisplayUnitXib.h"

@implementation DisplayUnitXib

+ (DisplayUnitView *)initDisplayUnitView {
    DisplayUnitXib *xib = [DisplayUnitXib new];
    [[NSBundle mainBundle] loadNibNamed:@"DisplayUnit" owner:xib topLevelObjects:nil];
    return xib.displayUnitView;
}


+ (DisplaySettingsView *)initDisplaySettingsView {
    DisplayUnitXib *xib = [DisplayUnitXib new];
    [[NSBundle mainBundle] loadNibNamed:@"DisplaySettings" owner:xib topLevelObjects:nil];
    return xib.settingsPanel;
}


@end
