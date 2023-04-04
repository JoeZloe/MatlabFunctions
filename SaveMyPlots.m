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

if exist( 'plots', 'dir' ) == 0
    mkdir plots
else
    % do nothing
end

cd([char(cd), '\plots']);

FigureHandles = sort(get(0, 'Children'));
NFigures = numel(FigureHandles);

for i = 1 : NFigures
    figure(FigureHandles(i));
    sgT = sgtitle;
    sgT = erase(sgT.String, " ");
    try
        exportgraphics(FigureHandles(i), [char(sgT) filextention], ...
                                        'ContentType', type);
    catch
        sgT = input(['The title:\n' char(sgT) ...
                     '\n is not working as title, enter custom: \n'], 's');
        exportgraphics(FigureHandles(i), [char(sgT) filextention], ...
                                        'ContentType', type);
    end
end

cd ..
end