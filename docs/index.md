---
layout: page
---

<div class="header">
    <div class="appname">{{ site.title }}</div>
    <div class="model">
        <model-viewer id="model" alt="A 3D model of the Little Luggable cyberdeck: a Raspberry Pi 5 and a custom mechanical keyboard built into a Pelican 1150 case" auto-rotate-delay="0" rotation-per-second="45deg" camera-controls interaction-prompt="none" orientation="0 0 225deg" camera-orbit="0deg 54.736deg auto" src="models/little-luggable.glb" poster="/images/poster.webp" shadow-intensity="1" high-performance="low-power"  disable-zoom>
            <div slot="progress-bar"></div>
            <noscript>
                <img class="poster-fallback" src="/images/poster.webp" alt="A 3D render of the Little Luggable cyberdeck: a Raspberry Pi 5 and a custom mechanical keyboard built into a Pelican 1150 case">
            </noscript>
        </model-viewer>
    </div>
    <div class="tagline">{{ site.description }}</div>
</div>

The Little Luggable is my take on a cyberdeck. Built around the [Raspberry Pi](https://www.raspberrypi.com/products/raspberry-pi-5/) and the [Pelican 1150 Protector Case](https://www.peli.com/eu/en/product/cases/protector/1150), it features a [fully-custom mechanical keyboard](/docs/keyboard) designed to perfectly fit the lid of the 1150.
{: .center}
