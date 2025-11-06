//
//  Display.swift
//  Brisync
//
//  Created by Krzysztof Czarnota on 05/11/2025.
//  Copyright © 2025 czarny. All rights reserved.
//

import Foundation
import CoreGraphics
import AppleSiliconDDC


enum DDCCommand: UInt8 {
    case brightness = 0x10
}


@objc class Display: NSObject {
    @objc public var name = ""
    @objc public var serial = ""
    @objc public var brightness: Int = 0

    init(name: String = "", serial: String = "") {
        self.name = name
        self.serial = serial
    }

    private var settings: [String: Any] {
        let defaults = UserDefaults.standard.dictionary(forKey: "DisplaySettings") ?? [:]
        if let serial = serial.nonEmpty, let specific = defaults[serial] as? [String: Any] {
            return specific
        } else if let general = defaults[""] as? [String: Any] {
            return general
        }
        return [:]
    }

    private func saveSettings(_ newSettings: [String: Any]) {
        var defaults = UserDefaults.standard.dictionary(forKey: "DisplaySettings") ?? [:]
        defaults[serial.nonEmpty ?? ""] = newSettings
        UserDefaults.standard.set(defaults, forKey: "DisplaySettings")
        UserDefaults.standard.synchronize()
    }

    @objc public var brightnessMap: [Int] {
        get {
            return settings["BrightnessMap"] as? [Int] ?? Array(repeating: 100, count: 11)
        }
        set {
            var updated = settings
            updated["BrightnessMap"] = newValue
            saveSettings(updated)
        }
    }

    @objc public var maxBrightnessValue: Int {
        get {
            return settings["MaxBrightnessValue"] as? Int ?? 100
        }
        set {
            var updated = settings
            updated["MaxBrightnessValue"] = newValue
            saveSettings(updated)
        }
    }

    @objc public func adjustToLevel(_ brightness: UInt) -> UInt {
        let scope = min(brightness / 10, 9)
        let x = Int(brightness % 10)
        guard brightnessMap.count > Int(scope + 1) else { return brightness }

        let y0 = brightnessMap[Int(scope)]
        let y1 = brightnessMap[Int(scope + 1)]
        let a = Float(y1 - y0) / 10.0
        let mappedValue = roundf(a * Float(x) + Float(y0))

        let percent = min(Int(mappedValue), 100)
        return UInt(percent)
    }
}

@objc class DDCDisplay: Display {
    let display: AppleSiliconDDC.IOregService

    init(display: AppleSiliconDDC.IOregService) {
        self.display = display
        super.init(name: display.productName, serial: display.alphanumericSerialNumber)
    }


    @objc public override var brightness: Int {
        get {
            let value = AppleSiliconDDC.read(service: display.service, command: DDCCommand.brightness.rawValue)!
            let result = Int(Float(value.current)/Float(value.max) * 100)
            return result
        }
        set {
            let scaled = (newValue * maxBrightnessValue) / 100
            _ = AppleSiliconDDC.write(service: display.service, command: DDCCommand.brightness.rawValue, value: UInt16(exactly: scaled)!)
        }
    }
}


@objc class CGDisplay: Display {
    let displayID: CGDirectDisplayID

    init(displayID: CGDirectDisplayID) {
        self.displayID = displayID
        super.init(name: "", serial: "")
    }


    @objc public override var brightness: Int {
        get {
            var brightness: Float = 0
            _ = DisplayServicesGetBrightness(displayID, &brightness)
            let result = Int(brightness * 100)
            return result
        }
        set {
            let scaled = (Float(newValue) * Float(maxBrightnessValue)) / 100.0
            DisplayServicesSetBrightness(displayID, scaled)
        }
    }
}


private extension String {
    var nonEmpty: String? {
        return isEmpty ? nil : self
    }
}
