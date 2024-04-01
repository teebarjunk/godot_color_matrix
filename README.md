# Color Matrix v0.1

**Scroll down for previews**

*This is a work in progress so the project is messy.*

Apply and blend matrices to colorize a scenes or images.

No bulky complex shaders that struggle to blend together. Use easy handles to create matrices which make blending easy!

# Features
- 12 built in effects to start from & a tweakable blend amount.
- Duotone: Use two colors to blend between a grayscale image.
- Temperature: Make the image warm/red or cold/blue.
- Plus: Saturation, contrast, invert, hue shift...
- Live editor previews.
- Fast blending by using Godot's built in Projection class for matrix mult.
- Color blindness simulators.
- Automatic material setup for CanvasGroup.

![](./demo/screenshots/editor.png)

# Saving blends

Play around with the `Initial > initial_matrix` to create a blend you like.

To save the final matrix scroll down to `Result > result_matrix` and click the arrow at the right to save to disk.

Modifying the `result_matrix` won't do anything. Just modify `initial_matrix`.

# Previews
| | | |
|-|-|-|
|![](./demo/screenshots/adv_none.webp)|![](./demo/screenshots/adv_sepia.webp)|![](./demo/screenshots/adv_bgr.webp)|
|![](./demo/screenshots/adv_vintage.webp)|![](./demo/screenshots/adv_polaroid.webp)|![](./demo/screenshots/adv_technicolor.webp)|
|![](./demo/screenshots/adv_kodachrome.webp)|![](./demo/screenshots/adv_browni.webp)|![](./demo/screenshots/adv_lsd.webp)|
|![](./demo/screenshots/adv_predator.webp)|![](./demo/screenshots/adv_desaturate_luminance.webp)|![](./demo/screenshots/adv_night_vision.webp)|
|![](./demo/screenshots/adv_thermal.webp)|![](./demo/screenshots/Duotone.webp)|![](./demo/screenshots/cb_deuteranopia.webp)|
|![](./demo/screenshots/cb_protanopia.webp)|![](./demo/screenshots/cb_deuteranomaly.webp)|![](./demo/screenshots/cb_protanomaly.webp)|
|![](./demo/screenshots/cb_tritanopia.webp)|![](./demo/screenshots/cb_tritanomaly.webp)|![](./demo/screenshots/cb_achromatopsia.webp)|
|![](./demo/screenshots/cb_achromatomaly.webp)|||
