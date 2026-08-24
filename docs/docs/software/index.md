---
title: Software
---

# Operating System

The Little Luggable uses a Raspberry Pi, so you can use any operating system compatible with this incredibly versatile device. Personally, I am currently using Ubuntu Resolute 26.04.

# RTC

The Raspberry Pi 5 supports a [rechargeable real-time clock battery](https://www.raspberrypi.com/products/rtc-battery/) which is crucial if you're going to use it in a battery powered device like the Little Luggable.

In order to ensure the battery recharges, you'll need to add the following to your `config.txt`:

```plaintext
dtparam=rtc_bbat_vchg=3000000
```
