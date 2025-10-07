% Assuming 'output' is loaded, size: 150000x11
% 10 EEG channels + 1 label column (11th column)
%clearvars -except output
tic
% ---- User specifications ----
fs_eeg = 1000;                   % EEG sampling frequency in Hz (update to your actual value)
image_label = 7;                 % Which image label to analyze (1 to 10 as per your experiment)

% ---- Data extraction ----
% Extract the EEG channel 10
eeg_channel10 = output(:,10);

% Extract the label column
labels = output(:,11);

% Find indices belonging to the selected image label
image_indices = find(labels == image_label);

% Get the signal segment for this image
eeg_segment = eeg_channel10(image_indices);

% ---- Signal properties ----
N = length(eeg_segment);         % Number of data points for this image
t = (0:N-1) / fs_eeg;           % Generate time vector (seconds)
a = max(t);                     % Duration for FBSE basis interval

% ---- FBSE Coefficient setup ----
L = N;                          % Number of Bessel coefficients (full resolution)
k = (1:L)';                     % Order index for Bessel roots
xi_k = k * pi;                  % Approximate roots of J0 (can be improved, but typical for demos)

ak = zeros(L,1);                % Preallocate FBSE coefficient vector

% ---- Compute FBSE coefficients ----
for idx = 1:L
    J_basis = besselj(0, xi_k(idx) * t(:) / a);        % Column vector (N x 1)
    eeg_vec = eeg_segment(:);                          % Column vector (N x 1)
    integrand = eeg_vec .* J_basis;                    % Pointwise multiply
    denom = a^2 * (besselj(1, xi_k(idx)))^2;           % Scalar
    ak(idx) = 2 / denom * trapz(t, integrand);         % Scalar result
end

% ---- Plotting ----
figure;

subplot(3,1,1);
plot(t, eeg_segment);
xlabel('Time (s)');
ylabel('EEG amplitude');
title(['EEG Channel 10 for Image Label ' num2str(image_label)]);

subplot(3,1,2);
plot(1:L, ak);
xlabel('Order');
ylabel('FBSE coefficient');
title('Order-zero FBSE coefficients');

% Map orders to frequency (Hz)
freqs = xi_k / (2*pi*a);

subplot(3,1,3);
plot(freqs, abs(ak));
xlabel('Frequency (Hz)');
ylabel('Magnitude of FBSE coefficient');
title('Magnitude of FBSE coefficients vs Frequency');

% Compute ak as needed for each image
% label2 = image_label + 10;
% varname = sprintf('natural%d', label2);   % change 'animated' to 'natural' for natural images
% eval([varname ' = ak;']);
% save_filename = sprintf('natural%d.mat', label2);
% save(save_filename, varname);

toc



