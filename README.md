# Little Luggable

[![build](https://github.com/jbmorley/little-luggable/actions/workflows/build.yml/badge.svg)](https://github.com/jbmorley/little-luggable/actions/workflows/build.yml)

Raspberry Pi Cyberdeck

![Photo of the Lunchbox Luggable sitting on a desk](images/hero.jpg)

## Overview

The Little Luggable is my take on a cyberdeck. It's built around the [Raspberry Pi 5](https://www.raspberrypi.com/products/raspberry-pi-5/) and the [Pelican 1150 Protector Case](https://www.peli.com/eu/en/product/cases/protector/1150). It includes a [fully-custom mechanical keyboard](/docs/keyboard) designed to perfectly fit the lid of the 1150.

Check out the [project page](https://little-luggable.jbmorley.co.uk) for more.

## Parts

Where possible, the Little Luggable uses off-the-shelf parts. I've separated these out and tried to provide links to places you can purchase standard parts. The links are currently pretty UK / US centric and I'd love pull requests for options for other markets.

### Screen and Computer

![](images/renders/screen-assembly.png)

#### Off-the-shelf

| **Part**                                                     | **Quantity** |
| ------------------------------------------------------------ | ------------ |
| [Raspberry Pi 4 Model B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) | 1            |
| [Raspberry Pi Touch Display](https://www.raspberrypi.com/products/raspberry-pi-touch-display/) | 1            |
| [PiJuice HAT](https://uk.pi-supply.com/products/pijuice-standard) | 1            |
| [PiJuice 12000mAh Battery](https://uk.pi-supply.com/products/pijuice-12000mah-battery) | 1            |
| [Pelican 1150 Protector Case](https://peliproducts.co.uk/products/1150-protector-case) | 1            |
| [Pelican 1150 Panel Frame](https://peliproducts.co.uk/products/1150-panel-frame) | 1            |
| [M3 Washer](https://www.amazon.co.uk/3mm-Flat-Washer-Form-Stainless/dp/B08TDPSBBY) | 4            |
| [M3 Spacer, 3mm](https://www.amazon.co.uk/dp/B0BHJP3KJP)     | 6            |
| [Raspberry Pi Standoff Set, 11mm](https://thepihut.com/products/raspberry-pi-standoff-set-11mm) | 1            |
| [USB-C Keystone Jack](https://www.amazon.co.uk/dp/B07Z947FRN) | 2            |
| [RJ45 Keystone Jack](https://www.amazon.co.uk/dp/B07KMQPC3L) | 1            |
| [USB-A Keystone Cable](https://www.amazon.co.uk/dp/B09B3YC29M) | 1            |

#### Custom

- Fascia, 3mm Acrylic, Laser Cut

  ![](images/renders/screen-fascia.png)

- Mounting Plate, 1mm Aluminium, Laser Cut
  ![](images/renders/screen-mounting-plate.png)

## Useful References

- Generating renders for the documentation:
  1. Render using Fusion 360 with a white, solid color background, and no ground plane
  2. Trim the resulting image using [mogrify](https://imagemagick.org/script/mogrify.php):
     ```bash
     mogrify -trim -bordercolor white -border 60 render.png
     ```

- [Keystone cutout details](https://www.phoenixcontact.com/en-pc/products/rj45-socket-insert-cuc-k-j1zni-s-r4idc8-1419021)
  ![](images/keystone-cutout.jpg)

- [Recommended Tapping Drill and Clearance Hole Sizes](https://international.optimas.com/technical-resources/tapping-sizes/)

# License

Little Luggable is copyright (c) 2022-2026 Jason Morley (see [COPYRIGHT](COPYRIGHT)) and licensed under Creative Commons Attribution 4.0 (CC BY 4.0) (see [LICENSE](LICENSE)).
