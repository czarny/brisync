//
//  DisplayManager.swift
//  Brisync
//
//  Created by Krzysztof Czarnota on 05/11/2025.
//  Copyright © 2025 czarny. All rights reserved.
//

import Foundation
import Cocoa
import AppleSiliconDDC
import CoreGraphics





@objc class DisplayManager: NSObject {
    @objc public private(set) var externalDisplays: [Display]
    @objc public private(set) var appleDisplay: Display?

    @objc public override init(){
        // Load build in dispaly
        var displayCount: UInt32 = 0
        var onlineDisplayIDs = [CGDirectDisplayID](repeating: 0, count: 8)
        _ = CGGetOnlineDisplayList(UInt32(onlineDisplayIDs.count), &onlineDisplayIDs, &displayCount)

        for i in 0..<Int(displayCount) {
            let displayID = onlineDisplayIDs[i]
            let isBuiltin = CGDisplayIsBuiltin(displayID) != 0
            if(isBuiltin) {
                self.appleDisplay = CGDisplay(displayID: displayID)
            }
        }


        // Load external displays
        self.externalDisplays = []
        let displays = AppleSiliconDDC.getIoregServicesForMatching()
        for d in displays {
            if(d.location != "Embedded") {
                self.externalDisplays.append(DDCDisplay(display: d))
            }
        }

        super.init()
    }
}
