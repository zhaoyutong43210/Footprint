function geojson_txt = gpx2geojson(filename)

if nargin <1
   info = struct2cell(dir('*.gpx'));
   filename = info(1,:);
    % filename{1} = 'QC_MTL_Paradis_Lake_with_Beaver_Dam.gpx';
    % filename{2} = 'QC_MTL_Sept_Chutes.gpx';
end

geojson_txt = [];

header1 = ['{',newline,'"type": "FeatureCollection",',newline,...
            '"features": [',newline];



footer1 = [']',newline,'}'];
footer2 = ['}',newline,'}'];


for n = 1:length(filename)

    fn = char(filename{n});
    %disp(fn)
P = gpxread(fn,'FeatureType','track');

P = downsampling_geopint(P);

infmt = 'yyyy-MM-dd''T''HH:mm:ss''Z''';

keplerfmt = 'yyyy/MM/dd HH:mm';

% some file doesn't have time series
try
dt = datetime(string(P.Time),'InputFormat',infmt,'TimeZone','-05:00');
catch
end

data = [P.Longitude' P.Latitude'  P.Elevation' ];

txt = jsonencode(data);

meta = [];

meta.source = 'Alltrails Export (gpx track)';

if exist("dt","var")
    meta.time = datetime(dt(1),'Format',keplerfmt);
    meta.time_end = datetime(dt(end),'Format',keplerfmt);
    meta.name = fn(1:end-4);
elseif  contains(fn,"#")
    idx = strfind(fn,'#');
    time = fn(idx+1:end);
    year = str2double(time(1:4));
    month = str2double(time(5:6));
    day = str2double(time(7:8));
    meta.time = datetime(datetime(year,month,day),'Format',keplerfmt);
    meta.name = fn(1:idx-1);
else 
    meta.time = ' ';
    meta.name = fn(1:end-4);
    msg = ['no time data found in ',fn,'!'];
    warning(msg)
end
clear dt

info_add = jsonencode(meta);

header2 = ['{',newline,'"type": "Feature",',newline,...
            '"properties": ',info_add,newline,...
            ',',newline,...
            ' "geometry": {',newline,'"type": "LineString",',newline,...
            '"coordinates":'];

geojson_txt0 =[header2,newline ,txt,newline,footer2];

if n >1
geojson_txt = [geojson_txt,',',newline,geojson_txt0];
else
geojson_txt = [geojson_txt,newline,geojson_txt0];
end

end


geojson_txt = [header1, geojson_txt, footer1];

fileID2 = fopen('alltrails_export.json','w');
status = fprintf(fileID2,'%c',geojson_txt);
fclose(fileID2);

end
% =========================================================================
