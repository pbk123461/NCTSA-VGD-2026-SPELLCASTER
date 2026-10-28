# NCTSA-VGD-2026-SPELLCASTER

https://www.cocrea.world/gandi?projectId=1990815093517029378&amp;inviteToken=uinDE5W5F

# Lottes Shader Parameters

Below are the base configuration parameters and presets for this shader.

## Base Configuration

```glsl
//==============================================================
// HARDCODED PARAMETERS - Adjust these values directly in code
//==============================================================
#define HARD_SCAN -4.0  // Scanline hardness (-8.0 = soft, -16.0 = hard)
#define HARD_PIX -2.0   // Pixel hardness (-2.0 = soft, -4.0 = hard)
#define WARP_X 0.0      // Horizontal screen warp (0.0 = flat)
#define WARP_Y 0.0      // Vertical screen warp (0.0 = flat)
#define MASK_DARK 0.7   // Shadow mask darkest value
#define MASK_LIGHT 1.2  // Shadow mask brightest value
#define BRIGHT_BOOST 1.1 // Overall brightness multiplier
#define SHAPE 2.0       // Gaussian filter shape
```

---

## Presets

### Preset 1: Classic Arcade (Default)
```glsl
#define HARD_SCAN -8.0
#define HARD_PIX -3.0
#define WARP_X 0.031
#define WARP_Y 0.041
#define MASK_DARK 0.5
#define MASK_LIGHT 1.5
#define BRIGHT_BOOST 1.0
#define SHAPE 2.0
```

### Preset 2: Sharp Monitor (Minimal Effects)
```glsl
#define HARD_SCAN -4.0
#define HARD_PIX -2.0
#define WARP_X 0.0
#define WARP_Y 0.0
#define MASK_DARK 0.7
#define MASK_LIGHT 1.2
#define BRIGHT_BOOST 1.1
#define SHAPE 2.0
```

### Preset 3: Heavy CRT Effect
```glsl
#define HARD_SCAN -12.0
#define HARD_PIX -4.0
#define WARP_X 0.05
#define WARP_Y 0.05
#define MASK_DARK 0.4
#define MASK_LIGHT 1.6
#define BRIGHT_BOOST 0.9
#define SHAPE 2.0
```

### Preset 4: Pixel Art Perfect
```glsl
#define HARD_SCAN -12.0
#define HARD_PIX -4.0
#define WARP_X 0.0
#define WARP_Y 0.0
#define MASK_DARK 0.6
#define MASK_LIGHT 1.4
#define BRIGHT_BOOST 1.05
#define SHAPE 2.0
```

### Preset 5: Flat Modern CRT
```glsl
#define HARD_SCAN -6.0
#define HARD_PIX -2.5
#define WARP_X 0.01
#define WARP_Y 0.01
#define MASK_DARK 0.6
#define MASK_LIGHT 1.4
#define BRIGHT_BOOST 1.05
#define SHAPE 2.0
```
