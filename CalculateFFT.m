function [Amplitude, Phase] = CalculateFFT(SignalData, SampFreq, varargin)
% CalculateFFT calculates the FFT and plots the Spectrum in frequency
% domain

if nargin > 4
    error('Incorrect number of input arguments.')

elseif nargin < 2
    if ~exist('SignalData', 'var')
        error(['Not enough input arguments. ' ...
            'Please enter signal data and sampling frequency.']);

    elseif ~exist('SampFreq', 'var')
        error('Please enter sampling frequency.')

    end

elseif nargin == 2
    XScal = 1;
    Plotting = true;

elseif nargin == 3
    XScal = 1;
    Plotting = varargin{1};

elseif nargin == 4
    Plotting = varargin{1};
    XScal = varargin{2};

end

% checking for correct input
NumSig = size(SignalData, 1);
if NumSig ~= size(SampFreq, 1)
    error('Amount of signals is not consistent with the amount of sampling frequencies!');

elseif isempty(Plotting)
    Plotting = true;

end


N = length(SignalData);

% Calculating the FFT 
Amplitude = nan(NumSig, N/2);
Phase = nan(NumSig, N/2);
for i = 1 : NumSig
    TransSignal = fft(SignalData(i, :));

    Amplitude(i, :) = abs(TransSignal(1:N/2));
    Amplitude(i, :) = 2 * Amplitude(i, :) / N;
    Amplitude(i, 1) = Amplitude(i, 1) / 2;
    
    Phase(i, :) = angle(round(TransSignal(1 : N/2), 6));    
end

% plotting the one sided spectrum
if Plotting
    k = 0 : (N/2) - 1;
    f = k * SampFreq(i) / N * XScal;
    for i = 1 : NumSig
        figure;
        t = tiledlayout(2, 1);
        ax1 = nexttile;
        stem(ax1, f, Amplitude(i, :)); grid on; 

        ax2 = nexttile;
        stem(ax2, f, Phase(i, :)); grid on;

        title(ax1, "One-Sided Phase Spectrum", 'Interpreter', 'latex');
        title(ax2, "One-Sided Magnitude Spectrum", 'Interpreter', 'latex');
        xticklabels(ax1,{})
        xlabel(ax2, "f [Hz] $\rightarrow$", 'Interpreter', 'latex');
        ylabel(ax1, 'abs(X(t)) $\rightarrow$', 'Interpreter', 'latex');
        ylabel(ax2, "arg(X(t)) $\rightarrow$", 'Interpreter', 'latex');

        t.TileSpacing = 'compact';
    end
end