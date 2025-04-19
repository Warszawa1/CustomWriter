# CustomWriter App Documentation

## Overview
CustomWriter is a specialized NFC tag writing utility designed to create tags that work with my other application. This tool lets you program NFC tags with specific data that can be recognized by both Android and iOS devices.

<table>
  <tr>
    <td>
      <img src="screenshots/screen1.png" alt="Initial Screen" width="400"/>
      <p align="center">Initial Screen</p>
    </td>
    <td>
      <img src="screenshots/screen2.png" alt="NFC Scanning" width="400"/>
      <p align="center">NFC Scanning</p>
    </td>
  </tr>
  <tr>
    <td>
      <img src="screenshots/screen3.png" alt="Writing Complete" width="400"/>
      <p align="center">Writing Complete</p>
    </td>
    <td>
      <img src="screenshots/screen4.png" alt="Tag Usage" width="400"/>
      <p align="center">Tag Usage</p>
    </td>
  </tr>
</table>



## Functionality
The app writes two types of records to an NFC tag:
1. **URL Record**: Contains a custom URL scheme that iOS devices recognize
2. **MIME Record**: Contains a custom MIME type with payload "toggle_focus" that Android devices recognize

## How It Works
When you write a tag using CustomWriter:
- The app creates a dual-format tag containing both iOS and Android compatible records
- When scanned by an iOS device, it launches the PresentCup app via the custom URL scheme
- When scanned by an Android device, it triggers the app via the custom MIME type

## Using the App
1. Tap "Write to NFC Tag"
2. Hold your iPhone near an NFC tag when prompted
3. The app will write the necessary data to the tag
4. The tag is now ready to use with both iOS and Android devices

## Regarding Separate vs. Combined Tags

### Combined Tags (Recommended)
- **Convenience**: One tag works for all devices
- **Simplicity**: Easier for users who have both platforms or share with others
- **Space Efficiency**: Most NFC tags have plenty of space for both record types
- **Cost Effective**: Requires fewer tags overall

### Separate Tags
- **Slightly Faster**: Marginally faster scanning with platform-specific tags
- **More Customization**: Could customize behavior differently for each platform
- **Cleaner Data Structure**: Each tag contains only what's needed for one platform

Given the small size of both records and the convenience factor, the combined approach is recommended for most users.
