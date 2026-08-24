---
title: Model
priority: -100
---

The website uses [`<model-viewer>`](https://modelviewer.dev) to display a 3D model of the Little Luggable.

# Model

There are a number of steps to generate a suitable model:

1. Export from Fusion as a USDZ file.
2. Import the USDZ file into Blender.
3. Manually update the materials as Fusion does a terrible job when exporting materials.
    1. Create the materials in Blender by importing and running `scripts/blender-materials.py`.
    2. Select each element in-turn, delete the original material, and assign the correct new material.
4. Export the model as a GLB file.
5. Optimize the model:
   ```sh
   scripts/optimize-model.sh \
       exports/little-luggable.glb \
       docs/models/little-luggable.glb
   ```

> [!IMPORTANT]
>
> Do not check the un-optimized model in; it's massive.

# Poster

`<model-viewer>` supports a 'poster' which is displayed while the model is loading, or if JavaScript is disabled. This is generated using `<model-viewer>` itself to ensure it displays identically and the transition from poster to model is seamless.

1. Serve the site and open the front page:
   ```sh
   cd docs
   bundle install
   bundle exec jekyll serve --watch
   ```
2. Run in the console, and move the download into `docs/images/`:
   ```js
   const v = document.querySelector('#model');
   const blob = await v.toBlob({ idealAspect: true, mimeType: 'image/webp', qualityArgument: 0.85 });
   Object.assign(document.createElement('a'), {
       href: URL.createObjectURL(blob),
       download: 'poster.webp',
   }).click();
   ```
4. Reference it from the element: `poster="/images/poster.webp"`.
