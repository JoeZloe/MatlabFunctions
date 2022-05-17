function ArrangeFigures(varargin)
% arrangeFigures automatically aranges open figures in a grid on the
% designated screen monitor and puts them into the foreground.
% 
% 
% Options are:
% - arrangefigures
% - arrangefigures(monitor)
% - arrangefigures(monitor, fRatio)
%
% Possible settings are:
% - monitor:
%    - default: 2
%    - 0 means all monitors
%    - scalar input means specified monitor
%    - array input means multiple chosen monitors. Monitors must be successive
% - fRatio:
%    - default: 3/4
%    - set the figure ratio in height/width (default: 3/4)

if nargin > 3
    warning('Incorrect number of input arguments. Leaving figures unchanged.')
    return
elseif nargin == 0
    Monitor = 2;
    fRatio = 3/4;
elseif nargin == 1
    Monitor = varargin{1};
    fRatio = 3/4;
elseif nargin == 2
    Monitor = varargin{1};
    fRatio = varargin{2};
end

Spacer = 40;

% get figure handles
FigureHandles = sort(get(0, 'Children'));
NFigures = numel(FigureHandles);

% get number of monitors and the resolutions
MonitorExtends = get(0, 'MonitorPositions');
NMonitors = size(MonitorExtends, 1);

if Monitor == 0
    Monitor = 1:NMonitors;
end

% check if monitor-array exceeds number of monitors
if min(Monitor) > NMonitors
    warning(['Cannot find assigned monitor: [' num2str(Monitor), newline, ...
        ']. -> Set display monitor: 1'])
    Monitor = 1;

elseif min(Monitor) < 1
    Buffer = Monitor;k,
    Monitor = Monitor(Monitor > 0);
    warning(['Cannot find assigned monitor: [' num2str(Buffer), ']', newline, ...
        'Set display monitor: [' num2str(Monitor) ']. -> Skipping monitors < 0']);
    clear Buffer;

    if numel(Monitor) == 0
        warning('No monitors > 0 assigned. -> Set display monitor: 1')
        Monitor = 1;
    end

elseif max(Monitor) > NMonitors
    Buffer = Monitor;
    Monitor = Monitor(Monitor <= NMonitors);
    warning(['Cannot find assigned monitor: [' num2str(Buffer), ']', newline, ...
        'Set display monitor: [' num2str(Monitor) ']. -> Skipping monitors > ' ...
        num2str(NMonitors)]);

elseif isempty(Monitor)
    error('Assign a correct monitor!')
end

UsedMonitorExtends = MonitorExtends(Monitor, :);
TaskbarOffset = 50;
MonitorArea = [min(UsedMonitorExtends(:, 1:2), [], 1) ...
               max(UsedMonitorExtends(:, 3:4), [], 1)];
x = MonitorArea(1);
y = MonitorArea(2);
w = MonitorArea(3) * size(UsedMonitorExtends, 1);
h = MonitorArea(4) - TaskbarOffset; % 100 offset for taskbar

% determine size of figures and grid to maximize area covered with figures
HightSpacer = 50;
if ~exist('fw', 'var')
    FigureArea = 0;
    for NRows = 1:NFigures
        NCols = ceil(NFigures / NRows);
        fh = (h - Spacer) / NRows - Spacer - HightSpacer;
        fw = fh / fRatio;
        if fw > ((w - Spacer) / NCols - Spacer)
            fw = (w - Spacer) / NCols - Spacer;
            fh = fw * fRatio;
        end

        if FigureArea < fh * fw
            SetNRows = NRows;
            SetNCols = NCols;
            FigureArea = fh*fw;
        end
    end

    NRows = SetNRows;
    NCols = SetNCols;
    fh = (h - Spacer) / NRows - Spacer - HightSpacer;
    fw = (w - Spacer) / NCols - Spacer;

    if (fh/fw > fRatio)
        fh = fw * fRatio;
    else
        fw = fh / fRatio;
    end

else
    NCols = floor((w - Spacer) / (fw - Spacer));
    NRows = floor((h - Spacer) / (fh - Spacer));
    if (NCols * NRows < NFigures)
        warning(['Cannot display ' num2str(NFigures) ' figures using [w h] = [' ...
            num2str(w) ' ' num2str(h) '] on monitor ' num2str(Monitor) ...
            '. Leaving figures unchanged.']);
        return
    end
end

fw = floor(repmat(fw, [1 NFigures]));
fh = floor(repmat(fh, [1 NFigures]));
fx = repmat(Spacer + (0 : NCols - 1) * (fw(1) + Spacer), [1, NRows]) + x;
fy = (h - fh(1)) - sort(reshape(repmat(Spacer + (0 : NRows - 1) * ...
    (fh(1) + Spacer + HightSpacer), [NCols, 1]), 1, NCols * NRows), 'ascend') + y;

Offset = 0;
Ycoordinate = 0;
[~, SortFigPos] = sort([FigureHandles.Number]);
for n = 1:NFigures
    if fx(n) < MonitorArea(3) && fx(n) + fw(n) > MonitorArea(3)
        Offset = MonitorArea(3) + Spacer - fx(n);
        Ycoordinate = fy(n);
    elseif Ycoordinate ~= fx(n)
        Offset = 0;
    end

    fx(n) = fx(n) + Offset;
    set(FigureHandles(SortFigPos(n)), 'position', [fx(n) fy(n) fw(n) fh(n)])
end

for FigureHandle = FigureHandles'
    figure(FigureHandle);
end
end
