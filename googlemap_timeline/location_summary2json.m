
geotable_whole = table();
geojson_txt = [];

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

for n = 1:length(path_summary)

    path = path_summary(n,:);
    
    time = path{1};
    time_stamp = path{2};
    latitude = path{4};
    longitude = path{3};
    time_elaspe = path{5};
    
    P = geopoint(latitude,longitude,'Time',time);
    
    data = [P.Longitude' P.Latitude' ];

try
    [p, txtp] = OSRM_get_route(data);

    txt = jsonencode(data);
    
    geojson_txt0 = txtp;

    geojson_txt1 =[header2b,newline ,txt,newline,footer2];
    
    if n >1
        geojson_txt = [geojson_txt,',',newline,geojson_txt0];

        geojson_txt = [geojson_txt,',',newline,geojson_txt1];
    else
        geojson_txt = [geojson_txt, newline,geojson_txt0];
        geojson_txt = [geojson_txt,',',newline,geojson_txt1];
    end
    % geotable = table();
    % geotable.time =  time(1)+ minutes(time_elaspe');
    % geotable.time_stamp =  time_stamp(1) + 1/24*(time_elaspe')/60;
    % geotable.latitude = latitude';
    % geotable.longitude = longitude';
    % 
    % 
    % geotable_whole = [geotable_whole;geotable];

    plot(P.Longitude, P.Latitude,'bo')
    hold on 
    plot(p.Longitude, p.Latitude,'b-.')
    hold off
    pause(5)

catch ME

end

end

geojson_txt = [header1, geojson_txt, footer1];

fileID2 = fopen('geojson_test3.json','w');
status = fprintf(fileID2,'%c',geojson_txt);
fclose(fileID2);


%writetable(geotable_whole,'path_test.csv')