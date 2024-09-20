clear;
clc;
load('.\location_history_result.mat')

geotable_whole = table();
geojson_txt = [];

time_start = datetime(2022,01,01);
time_end = datetime(2022,12,31);

header1 = ['{',newline,'"type": "FeatureCollection",',newline,...
            '"features": [',newline];

header2a = ['{',newline,'"type": "Feature",',newline,...
            '"properties": {',newline,'"vendor":  "Alltrails_export"',newline,...
            '},',newline,...
            ' "geometry": {',newline,'"type": "LineString",',newline,...
            '"coordinates":'];

header2b = ['{',newline,'"type": "Feature",',newline,...
            '"properties": {',newline,'"vendor":  "Alltrails_export"',newline,...
            '},',newline,...
            ' "geometry": {',newline,'"type": "MultiPoint",',newline,...
            '"coordinates":'];

footer1 = [']',newline,'}'];
footer2 = ['}',newline,'}'];

r = 6370996.81; %m

my_path_array ={};
my_point_array ={};

ida = 1;
for n = 1:length(path_summary)

    path = path_summary(n,:);
    
    time = path{1};
    
    if (time(1) <time_start) || (time(2) > time_end)
        continue
    end

    time_stamp = path{2};
    latitude = path{4};
    longitude = path{3};
    time_elaspe = path{5};
    
    P = geopoint(latitude,longitude,'Time',time);
    
    data = [P.Longitude' P.Latitude' ];

try
    [p, txtp] = OSRM_get_route(data);


    % geotable = table();
    % geotable.time =  time(1)+ minutes(time_elaspe');
    % geotable.time_stamp =  time_stamp(1) + 1/24*(time_elaspe')/60;
    % geotable.latitude = latitude';
    % geotable.longitude = longitude';
    % 
    % 
    % geotable_whole = [geotable_whole;geotable];

    % plot(P.Longitude, P.Latitude,'bo')
    % hold on 
    % plot(p.Longitude, p.Latitude,'b.-')
    % hold off

    dist = [];
    for i = 1:length(P)
        point = [P.Latitude(i); P.Longitude(i)];
        pathcurve = [p.Latitude;  p.Longitude];
        
        d = pathcurve - point;
        lx = d(2,:) * r * cosd(point(1));
        ly = d(1,:) * r ;

        dist(i) = min(sqrt((lx.^2+ly.^2)));
        
    end 
    pause(3)
    ind = (dist<1e3);
    
    plot(P.Longitude, P.Latitude,'bo')
    hold on 
    plot(p.Longitude, p.Latitude,'b.-')

    plot(P.Longitude(~ind), P.Latitude(~ind),'r*')
    hold off
    
    data2 = [P.Longitude' P.Latitude' ];
    
    txt = jsonencode(data2(~ind,:));
    
    geojson_txt0 = txtp;

    geojson_txt1 =[header2b,newline ,txt,newline,footer2];
    
    if n >1
        geojson_txt = [geojson_txt,',',newline,geojson_txt0];

        geojson_txt = [geojson_txt,',',newline,geojson_txt1];
    else
        geojson_txt = [geojson_txt, newline,geojson_txt0];
        geojson_txt = [geojson_txt,',',newline,geojson_txt1];
    end

    my_point_array{ida} = data2;

    my_path_array{ida} = P;
    ida = ida+1;

catch ME
    msg = ['An error occured:',ME.message];
    warning(msg)
end

end

geojson_txt2 = [header1, geojson_txt, footer1];

fileID2 = fopen('geojson_test3.json','w');
status = fprintf(fileID2,'%c',geojson_txt2);
fclose(fileID2);

save(['google_timeline_',char(time_start),'to',char(time_end),'.mat'],...
    'my_point_array','my_path_array')