---
title: Renders
---

Generating renders for the documentation:

1. Render using Fusion with a white, solid color background, and no ground plane
2. Trim the resulting image using [mogrify](https://imagemagick.org/script/mogrify.php):
   ```bash
   mogrify -trim -bordercolor white -border 60 render.png
   ```
