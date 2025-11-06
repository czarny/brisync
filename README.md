# Brisync

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS](https://img.shields.io/badge/macOS-10.11+-blue.svg)](https://www.apple.com/macos)
[![Release](https://img.shields.io/github/v/release/czarny/brisync)](https://github.com/czarny/Brisync/releases)

---

<div align="center">

## 🎉 **NEW: Apple Silicon Mac Support!** 🎉

**Brisync 2 now fully supports Apple Silicon Macs!**

</div>

---

> Automatically synchronize your external display brightness with your Mac's built-in display

Brisync is a lightweight macOS menu bar application that intelligently adjusts the brightness of your external monitors to match your Mac's built-in display, creating a seamless viewing experience.

## ✨ Features

- 🔄 **Automatic Brightness Sync** - External displays automatically adjust when you change your Mac's brightness
- 📊 **Custom Brightness Curves** - Fine-tune brightness mapping for each external display individually
- 🎛️ **DDC/CI Protocol** - Brightness is adjusted
- ⚡ **Real-time Adjustment** - Instant brightness changes with no noticeable lag

## 🎯 How It Works

Brisync monitors your Mac's built-in display brightness and communicates with external displays via the DDC/CI interface. The application uses customizable brightness curves to map internal display brightness levels to appropriate external display values.

### Brightness Curve Configuration

Each external display can have its own brightness curve, allowing you to compensate for different panel characteristics:

1. Open Brisync settings from the menu bar
2. Select your external display
3. Adjust the sliders to set desired brightness levels at different points
4. The curve interpolates between these points for smooth transitions

## 💻 Compatibility

### Supported Macs
- **Apple Silicon**: Use Brisync 2
- **Intel-based Macs**: Use Brisync

## 📦 Installation

### Homebrew (Recommended)

```bash
brew install brisync
```

### Manual Installation

1. Download the latest release from [Releases page](https://github.com/czarny/Brisync/releases/latest)
2. Extract the `.zip` file
3. Move `Brisync.app` to your `/Applications` folder
4. Launch Brisync from Applications or Spotlight

### First Launch

On first launch, you may need to:
1. Right-click the app and select "Open" (if you see a security warning)
2. Grant necessary permissions in System Preferences → Security & Privacy


## Support the Project

If you find Brisync useful, consider supporting its development:

[![Donate with PayPal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate?hosted_button_id=NL7L7KNN7VBFC)
