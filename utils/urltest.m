

input = [13.388860,52.517037;
         13.397634,52.529407;
         13.397634,52.629407];

service_type = 'route'; % trip or route

coordinates = char(join(string(num2str(input,'%.6f,%.6f;')),''));

url = ['http://router.project-osrm.org/',service_type,'/v1/driving/',...
    coordinates(1:end-1),'?',...
    'geometries=geojson&overview=full'];
data = webread(url);

% if data.code
% 
% end

coor = data.routes.geometry.coordinates;

plot(coor(:,1),coor(:,2),'o-')

latitude = coor(:,2);
longitude = coor(:,1);
p = geopoint(latitude,longitude);

geojson_txt = geopoint2geojson(p);
