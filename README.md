# EEG-based-classification-for-natural-and-animated-scenes

> MATLAB & Python code for EEG signal acquisition, preprocessing, feature extraction, Bessel spectral analysis and classification.

---

## Overview

This repository implements the workflow for analyzing EEG signals recorded while subjects view natural and animated images. The goal is to extract discriminative features using traditional statistics and Fourier-Bessel Series Expansion (FBSE), enabling robust classification of brain responses by image category.

## Features

- **EEG Data Acquisition:** Scripts for synchronizing stimulus presentation and recording EEG from subjects exposed to 100 natural + 100 animated images.
- **Preprocessing:** Automated routines for artifact rejection, filtering, and epoching.
- **Feature Extraction:** Extraction of RMS, entropy, kurtosis, and FBSE coefficients.
- **Classification:** ML scripts (SVM, Random Forest, etc.) for image category prediction.
- **Visualization:** PCA/t-SNE dimensionality reduction and accuracy/loss plotting.


## Getting Started

1. Clone the repository:
    ```
    git clone https://github.com/yourusername/eeg-image-classification.git
    ```
2. Install dependencies (`MATLAB`, `Python 3`, `numpy`, `scikit-learn`, etc.)
3. Edit config files to set data directories.
4. Run `main_analysis.m` (MATLAB) or Jupyter Notebooks for feature extraction and classification.

## Usage

- Preprocess EEG data and epoch per image.
- Extract features with `/features/` scripts.
- Train and test classifiers using `/classification/`.
- Generate and review plots stored in `/figures/`.

## Results

- FBSE features improved classifier separation of EEG responses to natural vs. animated images.
- Demonstrated robust accuracy in multi-subject, multi-session data.
- Example figures available in `/figures/`.

## Credits

Developed by [Your Name], BTP Project  
EE/CS Department, [Your Institution], 2025

## License

MIT License


