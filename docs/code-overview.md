# Code Overview

[← Back to README](../README.md)

This document explains the original source code **as it is**. Nothing in `src/` was changed. Quoted comments are translated from Spanish.

## Files

| File | Type | Role |
| --- | --- | --- |
| `src/Proyecto.m` | MATLAB function (GUIDE-generated + hand-written callback) | GUI entry point and event handling |
| `src/Proyecto.fig` | Binary MAT-file (v5, PCWIN64) | GUI layout created with GUIDE |
| `src/braintumordetector.m` | MATLAB function | Tumor detection algorithm |

Execution flow:

```
Proyecto  (GUIDE figure)
   └── pushbutton1_Callback            "Seleccionar Imagen para analizar"
          ├── uigetfile → imread → rgb2gray
          ├── imshow(img, 'Parent', handles.axes3)
          └── braintumordetector(img)  → draws contour, returns getframe(gca)
```

---

## `src/Proyecto.m`

Standard GUIDE skeleton (`gui_mainfcn`, singleton, `OpeningFcn`/`OutputFcn`) plus the callbacks listed below.

### GUI components (from `Proyecto.fig`)

| Tag | Style | Text / Title |
| --- | --- | --- |
| `figure1` | figure | `Proyecto` |
| `uipanel3` | panel | `Anomalias en la masa encefalica` |
| `axes3` | axes | — (input image) |
| `axes4` | axes | — (intended for the result) |
| `edit1` | static text | `RMN` (label above `axes3`) |
| `text2` | static text | `Deteccion de Irregularidad` (label above `axes4`) |
| `pushbutton1` | push button | `Seleccionar Imagen para analizar` |

### Callbacks

| Function | Behavior |
| --- | --- |
| `pushbutton1_Callback` | Main logic: `cla`; `clear` of several variables; `uigetfile({'*.*','All Files'})`; `imread`; `rgb2gray`; show on `axes3`; call `braintumordetector(img)`. The line that would show the result on `axes4` is commented out. |
| `edit1_CreateFcn` | Empty (GUIDE stub). |
| `popupmenu1_Callback`, `popupmenu1_CreateFcn` | GUIDE stubs for a pop-up menu that **does not exist** in the current `.fig`. |
| `uibuttongroup1_SelectionChangedFcn` | Stub for a button group that **does not exist** in the current `.fig`. |
| `pushbutton2_Callback` | Empty stub for a second button that **does not exist** in the current `.fig`. |
| `setImg` / `getImg` | Small helpers that store an image in a `global img` variable. They are **not called** anywhere. |

The stubs for missing components suggest the GUI once had more controls (for example, a menu to pick between algorithms: the result variable is named `ImgAlgoritmo1`, "algorithm 1"). This is inferred and cannot be confirmed.

---

## `src/braintumordetector.m`

```matlab
function ImfinalF = braintumordetector(Im)
```

Input: a grayscale image (the GUI passes the output of `rgb2gray`, type `uint8`).
Output: the struct returned by `getframe(gca)` (fields `cdata`, `colormap`).

### Step by step

| # | Code | What it does |
| --- | --- | --- |
| 1 | `Im1=Im` | Copies the input. There is no semicolon, so the whole matrix is printed to the Command Window. |
| 2 | `H=ones(3)*(1/9); Im2=imfilter(Im1,H);` | 3×3 averaging (mean) filter. `Im2` is **not used** later. |
| 3 | `umbral=0.7; Im3=imbinarize(Im1,0.7);` | Global binarization with a fixed threshold of 0.7 (normalized intensity) on the **unfiltered** image. `umbral` is declared but the literal `0.7` is used. |
| 4 | `etiqueta=bwlabel(Im3);` | Labels connected components. |
| 5 | `regionprops(etiqueta,'Solidity','Area')` | Solidity (area / convex-hull area) and area of each region. |
| 6 | `area_alta_densidad=densidad>0.5; maxima_area=max(area(area_alta_densidad));` | Among regions with solidity > 0.5 ("high density"), finds the largest area. |
| 7 | `etiqueta_tumor=find(area==maxima_area); tumor=ismember(etiqueta,etiqueta_tumor);` | Builds a mask of the region(s) with that area. |
| 8 | `om=strel('square',5); tumor=imdilate(tumor,om);` | Dilates the mask with a 5×5 square. |
| 9 | `[B,L]=bwboundaries(tumor,'noholes');` | Traces the outer boundary of the mask. |
| 10 | `imshow(label2rgb(L,@jet,[1,0,0])); hold on; imshow(Im1);` | Shows a colored label image, then the grayscale image on top of it, in the **current axes**. |
| 11 | `contorno=B{:}; plot(contorno(:,2),contorno(:,1),'r','LineWidth',2);` | Plots the boundary in red. |
| 12 | `ImfinalF=getframe(gca);` | Captures the current axes as the return value. The commented-out lines show an earlier attempt to save it as `braintumordetected.jpg` and read it back. |

### Comments vs. actual behavior

The Spanish comments describe some steps differently from what the code does. They are documented here instead of being "fixed":

| Comment says | Code does |
| --- | --- |
| "Conversion of the image to grayscale" | `Im1=Im` (the conversion happens earlier, in `Proyecto.m`, with `rgb2gray`) |
| "Median filter" | Averaging (mean) filter `ones(3)/9` with `imfilter`, and its output is unused |
| "Segmentation … by Otsu's method" | Fixed threshold `0.7`. Otsu (`graythresh`) is not used |

### Techniques used

Averaging filter · global thresholding · connected-component labelling · region properties (solidity, area) · morphological dilation · boundary tracing · overlay visualization.

---

## Observed behavior notes

These are observations from reading the code. It was not executed for this documentation.

- The detection function draws on whatever axes is current (`gca`). In the GUI, the contour is therefore expected to appear on the input axes (`axes3`), not on `axes4`. This is inferred.
- If no region has solidity > 0.5, `maxima_area` is empty and the region mask is empty. `B` would then be empty, and the plotting step is expected to fail.
- The algorithm always selects exactly one "tumor" (the largest solid bright region). This may be the skull or scalp rather than a lesion when those are brighter than the threshold.

See [possible-improvements.md](possible-improvements.md) for ideas. None of them were applied.
