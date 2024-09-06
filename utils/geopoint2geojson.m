function geojson_txt = geopoint2geojson(P, ifsave)

geojson_txt = [];

header1 = ['{',newline,'"type": "FeatureCollection",',newline,...
            '"features": [',newline];

header2 = ['{',newline,'"type": "Feature",',newline,...
            '"properties": {',newline,'"vendor":  "Alltrails_export"',newline,...
            '},',newline,...
            ' "geometry": {',newline,'"type": "LineString",',newline,...
            '"coordinates":'];

footer1 = [']',newline,'}'];
footer2 = ['}',newline,'}'];


%P = downsampling_geopint(P);


data = [P.Longitude' P.Latitude'];

txt = jsonencode(data);

geojson_txt0 =[header2,newline ,txt,newline,footer2];


geojson_txt = [geojson_txt,newline,geojson_txt0];




if ifsave
    
    geojson_txt = [header1, geojson_txt, footer1];

    fileID2 = fopen('geojson_route_test.json','w');
    status = fprintf(fileID2,'%c',geojson_txt);
    fclose(fileID2);
end

end
