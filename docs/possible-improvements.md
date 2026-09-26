# Possible Improvements

[← Back to README](../README.md)

> **These improvements were NOT applied.** The code in `src/` is kept exactly as originally written to preserve the historical implementation. This list only records observations made while documenting the project.

## Correctness

- **Use the filtered image.** `Im2` (smoothed) is computed but `imbinarize` is applied to `Im1`. Binarizing `Im2` would match the documented pipeline.
- **Match comments and code.** Either use a real median filter (`medfilt2`) and Otsu's threshold (`graythresh` / `imbinarize(Im)` with default method), or update the comments to describe the averaging filter and the fixed threshold. Also remove the unused `umbral` variable, or use it.
- **Handle "no region found".** Check whether `maxima_area` is empty before continuing.
- **Handle multiple boundaries.** `contorno=B{:}` assumes a single boundary. Iterating over `B` would be more robust.
- **Handle grayscale inputs.** `rgb2gray` expects an RGB image. Check `size(imgL,3)` first.
- **Handle a cancelled file dialog.** `uigetfile` returns `0` when the user cancels.
- **Add the missing semicolon** on `Im1=Im` to avoid printing the whole image matrix.

## GUI

- Draw into the intended axes explicitly (for example, `imshow(..., 'Parent', ax)`, `plot(ax, ...)`), and show the result on `axes4` (*"Deteccion de Irregularidad"*).
- Replace `getframe(gca)` with returning the mask or boundary data. `getframe` depends on screen rendering, which likely produced the offset capture in `data/output/braintumordetected.jpg`.
- Remove unused stubs (`popupmenu1`, `uibuttongroup1`, `pushbutton2`, `setImg`/`getImg` and the `global` variable).
- GUIDE is deprecated in recent MATLAB releases. A port to App Designer (`.mlapp`) or a programmatic `uifigure` would keep the app usable.

## Algorithm

- Remove the skull first (skull stripping), so that the bright skull or scalp is not selected as the tumor.
- Use adaptive or Otsu thresholding instead of a fixed value, since MRI intensity varies between scans and sequences.
- Use more region criteria (eccentricity, mean intensity, position inside the brain mask) to pick the tumor.
- Report measurements (area in pixels, centroid), and allow a "no tumor detected" outcome.

## Repository / Engineering

- Convert the `.m` files from Latin-1 to UTF-8 (MATLAB R2020a+ defaults to UTF-8, so accents in comments may display incorrectly).
- Add a script to run the detector on all sample images in batch and save the results.
- Record the sources and licenses of the sample MRI images.
