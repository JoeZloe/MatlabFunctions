function SaveMyPlots(varargin)
% Saves all open figures by their sgtitle as image or vector file 
% SaveMyPlots(varargin)
%
% varargin can be:
%   - 'image' (standard)
%   - 'vector'

if isempty(varargin)
    type = 'image';
else
    type = varargin{1}; 
end

if strcmp(type, 'image')
    filextention = '.png';
elseif strcmp(type, 'vector')
    filextention = '.pdf';
else
    error('wrong input argument!');
end

FigureHandles = sort(get(0, 'Children'));
NFigures = numel(FigureHandles);

for i = 1 : NFigures
    figure(FigureHandles(i));
    sgT = sgtitle;
    sgT = erase(sgT.String, " ");
    exportgraphics(FigureHandles(i), [char(sgT) filextention], ...
                                        'ContentType', type);
end