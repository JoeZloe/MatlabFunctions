function [Amplitude, Phase] = CalculateFFT(SignalData, SampFreq, varargin)
% CalculateFFT calculates the FFT and plots the Spectrum in frequency domain

% vargin options:
% vargin{1} ... SavePlot    ... input a name for the figure
% vargin{2} ... XScal       ... Scaling for the x-Axis; 
%                               e.g.: 0.5 means from 0 to (0.5*fs) * 0.5
%                               for a one sided spectrum



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
    SavePlot = [];

elseif nargin == 3
    XScal = 1;
    SavePlot = varargin{1};

elseif nargin == 4
    SavePlot = varargin{1};
    XScal = varargin{2};
end

% checking for correct input
NumSig = size(SignalData, 1);
if NumSig ~= size(SampFreq, 1)
    error('Amount of signals is not consistent with the amount of sampling frequencies!');
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
k = 0 : (N/2) - 1;
f = k * SampFreq(i) / N * XScal;
for i = 1 : NumSig
    figure;
    TL = tiledlayout(2, 1);
    ax(1) = nexttile;
    stem(ax(1), f, Amplitude(i, :)); grid on; 

    ax(2) = nexttile;
    stem(ax(2), f, Phase(i, :)); grid on;

    title(ax(1), "One-Sided Phase Spectrum", 'Interpreter', 'latex');
    title(ax(2), "One-Sided Magnitude Spectrum", 'Interpreter', 'latex');
    xticklabels(ax(1),{})
    xlabel(ax(2), "f [Hz] $\rightarrow$", 'Interpreter', 'latex');
    ylabel(ax(1), 'abs(X(t)) $\rightarrow$', 'Interpreter', 'latex');
    ylabel(ax(2), "arg(X(t)) $\rightarrow$", 'Interpreter', 'latex');

    TL.TileSpacing = 'tight';
end


try
    ArrangeFigures;
catch
end

if ischar(SavePlot) || isstring(SavePlot)
    exportgraphics(TL, [char(SavePlot) '.pdf'], 'ContentType', 'vector');
end


