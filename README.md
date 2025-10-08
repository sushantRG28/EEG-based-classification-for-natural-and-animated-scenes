# EEG-based-classification-for-natural-and-animated-scenes

> MATLAB code for EEG signal acquisition, feature extraction, Bessel spectral analysis and classification.

This is my 4th year BTech project focused on EEG signal analysis for classifying responses to natural and animated images.

---

## Dataset Creation

We constructed a dataset consisting of 100 natural and 100 animated images, each selected at a strict resolution of **1920x1080** for consistency across trials. Subjects viewed each image for standardized test durations during EEG recording.

<p align="center">
  <img src="a.jpg" alt="Animated Image Example" width="320"/>
  <img src="b.jpg" alt="Natural Image Example" width="320"/>
</p>
<p align="center">
  <em>Sample animated and natural images from dataset (replace with your own images)</em>
</p>

---

## Hardware Setup

EEG signals were recorded using a BIOPAC MP150 system coupled with EEG100C amplifier modules. Precise stimulus event marking and synchronization was achieved via Cedrus StimTracker for reliable signal capture during each image presentation.

---

## Image Quality Metrics & Feature Analysis

Initial analysis applied established no-reference image quality metrics, including **PIQE**, **NIQE**, and **ILNIQE**, to quantify perceptual differences and generate baseline features for each image. These features were then used to compare classification results with EEG-derived metrics.

---

## EEG Feature Extraction and Classification

We extracted features from the EEG using advanced spectral methods—primarily the Fourier-Bessel Series Expansion (FBSE)—and compared their classification performance against traditional image metrics using the MATLAB Classification Learner app. Multiple classifier models and accuracy plots were generated for rigorous evaluation.

---

## Upcoming Work

We are currently extending our feature extraction pipeline to implement FBSE-based Empirical Wavelet Transform (FBSE-EWT) for further mode decomposition of EEG signals. Future experiments will also focus on comparing these new features to baseline metrics and optimizing classification across larger, multi-session datasets.

---

*Please see the project code and documentation for more details on preprocessing workflow, feature extraction scripts, and classification experiments.*



