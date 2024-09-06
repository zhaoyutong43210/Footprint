function [p,geojson_txt] = OSRM_get_route(input_points)

if nargin <1 
input_points = [13.388860,52.517037; % [long, lat;]
         13.397634,52.529407;
         13.397634,52.629407];
end
service_type = 'route'; % trip or route

coordinates = char(join(string(num2str(input_points,'%.6f,%.6f;')),''));

url = ['http://router.project-osrm.org/',service_type,'/v1/driving/',...
    coordinates(1:end-1),'?',...
    'geometries=geojson&overview=full'];
data = webread(url);

if strcmpi(data.code,'Ok')



coor = data.routes.geometry.coordinates;

%plot(coor(:,1),coor(:,2),'o-')

latitude = coor(:,2);
longitude = coor(:,1);
p = geopoint(latitude,longitude);

geojson_txt = geopoint2geojson(p, 0);

else 
geojson_txt =[];
warning('url bad request!')
end

end
