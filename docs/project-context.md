# Project Context

[← Back to README](../README.md)

## Classification

**Project origin: Academic / University Project** — a team project for a course on robotic vision.

No assignment statement, report, slides or other documents (PDF, Word, PowerPoint) exist in the repository, so everything below comes from the source code, the GUI layout file, file metadata and the images.

## Evidence

Legend: **Confirmed** = directly supported by a file · **Inferred** = reasonable deduction · **Unknown** = cannot be determined.

| Topic | Finding | Status | Source |
| --- | --- | --- | --- |
| Project type | *"PROYECTO DE VISIÓN ROBÓTICA"* (Robotic Vision project) | Confirmed | `src/braintumordetector.m`, line 2 |
| Topic | *"DETECCIÓN DE TUMORES CEREBRALES MEDIANTE PROCESAMIENTO DE IMÁGENES"* (brain tumor detection through image processing) | Confirmed | `src/braintumordetector.m`, line 3 |
| Authors | Team: José Manuel Barajas Ramírez and Omar Baruch Morón López | Confirmed | `src/braintumordetector.m`, lines 4–5 |
| Course name | *Visión Robótica* | Inferred | Header says "project of Robotic Vision"; this is most likely the course name |
| University / instructor | — | Unknown | Not mentioned anywhere |
| Original requirements | — | Unknown | No assignment document present |
| Development date | November 2018 | Confirmed | `% Last Modified by GUIDE v2.5 24-Nov-2018 16:28:22` in `Proyecto.m`; `Proyecto.fig` header "created Mon Nov 26 15:58:29 2018" |
| Platform | Windows 64-bit | Confirmed | `Proyecto.fig` header "platform PCWIN64" |
| Language of the project | Spanish (comments, GUI labels, file names) | Confirmed | Source and `.fig` |
| Publication on GitHub | 20 Feb 2021 | Confirmed | Git history (first two commits); `LICENSE`: "Copyright (c) 2021 Baruch Lopez" |
| State of completion | Working prototype with unfinished parts | Inferred | Unused callbacks, commented-out display of the result on the second axes (see [code-overview.md](code-overview.md)) |

## Goal and Scope

The goal was to build a MATLAB GUI that takes an MRI image (*RMN – Resonancia Magnética Nuclear*) and highlights a possible tumor using image processing covered in a robotic/computer vision course: filtering, thresholding, connected-component labelling, region properties, morphological dilation and boundary tracing.

Scope, as implemented:

- One image at a time, selected manually.
- Detection of a **single** region: the largest bright area with solidity above 0.5.
- Visual output only (red contour). No measurements, classification or report are produced.

The header comments also mention a median filter and Otsu's method. The code uses an averaging filter and a fixed threshold instead (see [code-overview.md](code-overview.md#comments-vs-actual-behavior)). The comments may describe an earlier plan or the intended method. The repository does not show which.

## GUI (recovered from `Proyecto.fig`)

The `.fig` file was inspected to recover the interface, since no screenshots were included:

- Window title: **Proyecto**
- Panel: **"Anomalias en la masa encefalica"** (anomalies in the brain mass)
- Left axes (`axes3`) with label **"RMN"** — the input image
- Right axes (`axes4`) with label **"Deteccion de Irregularidad"** (irregularity detection) — intended for the result
- Button (`pushbutton1`): **"Seleccionar Imagen para analizar"** (select image to analyze)

## Sample Data

`data/sample-mri/` contains seven brain MRI images (axial, sagittal and coronal views, various sequences). Six keep their original names, `WhatsApp Image 2018-11-24 at …`, which suggests they were shared between team members through WhatsApp on the day the GUI was last edited. At least one image has a visible stock-photo watermark, so the images appear to come from public web sources rather than a clinical dataset. Their exact origin and licensing are **unknown**.

Original file names were kept on purpose to preserve provenance.

## Historical Output

`data/output/braintumordetected.jpg` (481×320) has the same name as the file in a commented-out line of `braintumordetector.m`:

```matlab
% imwrite(Imfinal.cdata,'braintumordetected.jpg');
```

The image shows the lower part of an MRI slice and part of the **"…analizar"** button. This suggests it was produced by `getframe` capturing a screen region offset from the axes. That is a known side effect of `getframe` with display scaling, and would explain why the approach was commented out. This is **inferred** and cannot be confirmed.

## Repository History

| Date | Event |
| --- | --- |
| Nov 2018 | Project developed (GUIDE timestamps) |
| 20 Feb 2021 | Uploaded to GitHub: *"Initial commit"* (LICENSE) and *"Add files via upload"* (folders `bin/` and `RMN/`) |
| Later | Repository reorganized and documented. Source moved from `bin/` to `src/`, images moved from `RMN/` to `data/`. File contents were not changed |
