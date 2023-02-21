# Manufacture

## Settings

Settings for the [Makespace](https://makespace.org) laser cutters[^laser]:

[^laser]: These are for my own personal reference; you'll almost certainly want to do a few test cuts with your own laser cutter to dial in the correct settings.

- Jaws
  - 3mm acrylic
    - Speed = 10
    - Power = 85
    - Corner Power = 80

  - 1.5mm acrylic
    - Speed = 10
    - Power = 55
    - Corner Power = 55

- Betsy
  - 3mm acrylic
    - Speed = 10
    - Power = 90
    - Corner Power = 85

  - 1.5mm acrylic
    - Speed = 10
    - Power = 55
    - Corner Power = 55

N.B. When cutting 1.5mm acrylic, the kerfing[^kerf] seems to be about 0.2mm so dimensions need to be adjusted for high-tolerance parts like the keyboard mounting plate. For example, I found I needed to adjust the 14mm key-switch cutouts to be **13.8mm** to ensure the switches clip securely in place. I'm using the [DXF for Laser](https://apps.autodesk.com/FUSION/en/Detail/Index?id=7634902334100976871&appLang=en&os=Win64&autostart=true) plugin for Fusion 360 to automatically export kerf-adjusted parts.

[^kerf]: I'm measuring kerfing as the full width of the cut, meaning a 0.2mm kerf will shrink parts on each side of a cut by 0.1mm. I believe this is the correct definition of 'kerf' but wanted to clarify just in case my understanding was incorrect.


## Exports

Export as DXF using Adobe Illustrator for AutoCAD 2018:

<img alt="Screenshot of Adobe Illustrator DXF export dialog" src="../images/export-settings.png" width="615">

## Changes

### v1

### v2

### v3

- Add the power socket to the fascia and mounting bracket

### v4

- Initial prototype of the keyboard fascia and mounting plate

### v5

- Update the keyboard fascia to wrap around the keys
- Add power switch, reset switch, and USB-C port to the keyboard fascia
- Add mounting holes to the keyboard mounting plate
- Add collar for the keyboard latching switch
- Add keyboard PCB silhouette for fit testing

### v6

- Update the keyboard PCB silhouette to reposition the nice!nano and include the holes for the broaching nuts, and through-holes for the battery and power switch

### v7

- Update the keyboard fascia and mounting plate to [exactly] match the new PCB
- Add the keyboard mounting brackets

### v8

- Increase the M3 and M2.5 hole sizes across the screen and keyboard components (to 3.2mm and 2.7mm respectively)
- Increase the switch cutout diameter from 12mm to 12.5mm
- Increase the switch collar inner diameter to 12.25 and export an STL file for 3D printing
  - Add a screen switch collar (identical to the keyboard switch collar)
- Add a collar for the 90 degree keyboard USB-C port
- Update the bottom-left and bottom-right keyboard mounting brackets to actually centre the mounting holes on the case (and not the bottom row of keys)
- Add 0.2mm kerf-adjusted exports of the keyboard fascias and mounting plate
