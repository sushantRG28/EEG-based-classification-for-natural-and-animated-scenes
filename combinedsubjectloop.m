function features_all = combinedsubjectloop(Natural, Animated, channel)
fs=1000;

% Assume: fs (sampling frequency) is already set
subjectIdx = 6; % <-- change for the desired subject
numImages = 100;  % number of images per subject
%numChannels = 10; % adjust as per your data

features_all = cell(numImages, 1);  % to hold features for each image

for imgIdx = 1:numImages
    signal_matrix = Animated{subjectIdx, imgIdx}; % size: 5034 x numChannels
    % Optional: loop over channels if needed, e.g., for ch = 1:numChannels
    % Here, let's use the first channel as an example:
    signal = signal_matrix(:, channel);  % get one channel (5014 x 1)

    % --- Your preprocessing and FBSE-EWT code goes here ---
    zf = rajeshecgfiltering(signal, fs);
    f=zf;
    %figure,
    %plot(zf)
    % figure
    N=length(f);
    nb=(1:N);
    f=f';
    MM=N;
    %%%%%FBSE coefficents evaluation in an iterative way%%%%%%
    x=2;
    alfa=zeros(1,MM);
    for i=1:MM
        ex=1;
        while abs(ex)>.00001
            ex=-besselj(0,x)/besselj(1,x);
            x=x-ex;
        end
        alfa(i)=x;
        %fprintf('Root # %g  = %8.5f ex = %9.6f \n',i,x,ex)
        x=x+pi;
    end
    a=N;
    a3 = zeros(1, N);
    for m1=1:MM
        a3(m1) = (2 / (a^2 * (besselj(1, alfa(m1)))^2)) * sum(nb .* f .* besselj(0, (alfa(m1)/a) * nb));
    end
    %%%%root to frequency conversion%%%%%%%%
    freq1=(alfa*fs)/(2*pi*N);
    order=2;
    framelen=floor((N/(0.1*fs))+1);
    %%%%Instantaneous energy in FBSE domain%%%%%
    eng=((besselj(1,alfa(m1)).^2).*(length(f)^2).*(a3.^2))/2;
    a3new=sgolayfilt(eng,order,framelen);
    % plot(freq1, a3new)
    % plot(freq1, a3new)
    Nb=100;
    bound = LocalMax(a3new',Nb);
    fbound=freq1(bound);
    boundaries=bound;
    Npic=length(boundaries);
    % We compute gamma accordingly to the theory
    gamma=1;
    for k=1:Npic-1
        r=(boundaries(k+1)-boundaries(k))/(boundaries(k+1)+boundaries(k));
        if r<gamma 
            gamma=r;
        end
    end
    mfb=cell(Npic+1,1);
    %%%%FBSE domain scaling function (No concept of FFT here like EWT)%%
    mfb{1}=FBSE_domain_scaling_function(freq1, boundaries, gamma, N);
    %%%%FBSE domain wavelet function (No concept of FFT here like EWT)%%%
    for k=1:Npic-1
        mfb{k+1}=FBSE_domain_wavelet_function(freq1,boundaries(k),boundaries(k+1),gamma,N); 
    end
    mfb{Npic+1}=FBSE_domain_wavelet_function(freq1,boundaries(Npic),length(a3),gamma,N); 
    %%%%%show_boundaries%%%%%%%%%5
    % plot(freq1,a3);
    % hold on
    % for i=1:Npic
    %     line([freq1(boundaries(i)) freq1(boundaries(i))],[0 max(abs(a3))],'LineWidth',2,'LineStyle','--','Color',[1 0 0]);
    % end
    % figure,
    % for i=1:size(mfb)-1
    %     plot(freq1,mfb{i,1}, 'k', 'LineWidth', 1)
    %     hold on
    % end
    % xlim([0 45])
    % ylim([0 2])
    % title('FB domain-adaptive wavelet filter bank')
    
    %%%%FBSE domain mode reconstruction (No concept of IFFT here as in EWT)%%%
    D = zeros(N, MM);
    for m1=1:MM
        D(:,m1)=besselj(0,alfa(m1)/a*nb);
    end
    fbseewt=cell(length(mfb),1);
    for k=1:length(mfb)
        fbseewt{k}=((mfb{k})'.*a3);
        modes{k}=fbseewt{k}*D;
    end

    % After extracting modes, compute features:
    Nb = length(modes);  % or whatever number of modes
    means = zeros(1, Nb);
    stds = zeros(1, Nb);
    vars = zeros(1, Nb);
    for k = 1:Nb
        current_mode = modes{k};
        means(k) = mean(current_mode);
        stds(k) = std(current_mode);
        vars(k) = var(current_mode);
    end
    features = [means, stds, vars];
    features_all{imgIdx} = features;
    %fprintf('Finished processing Image %d\n', imgIdx);
end