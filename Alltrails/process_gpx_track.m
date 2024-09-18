function trip = process_gpx_track(file)

if nargin<1
    file = 'QC_MTL_Sept_Chutes.gpx';
end

earthRadius = 6371e3; % in meters
human_pace_range = [8 30]; % in min/km
data = gpxread(file);

lat = data.Latitude;
long = data.Longitude;
elev = data.Elevation;

infmt = 'yyyy-MM-dd''T''HH:mm:ss''Z''';

dt = datetime(string(data.Time),'InputFormat',infmt,'TimeZone','-05:00');


subplot(2,2,1)
plot(dt,elev,'.-')

subplot(2,2,2)
plot(dt,long, '.-')

subplot(2,2,3)
plot(dt,long, '.-')

subplot(2,2,4)
plot(lat,long, '.-')

elev_raw = [0,diff(elev)];
elev_mid = [0,diff(smoothdata(elev,"gaussian",60))];
elev_mid(elev_mid<0.0)=0;
elev_gain = cumsum(elev_mid);

dist = [];
speed = [];

wgs84 = wgs84Ellipsoid("m");

for n = 2:length(dt)

    lat1 = lat(n-1);
    lon1 = long(n-1);
    lat2 = lat(n);
    lon2 = long(n);
    arclen = distance(lat1,lon1,lat2,lon2,wgs84);
    
    dist(n) = arclen;%*pi/180;
end

dist_trip = cumsum(dist);

dist_s = smoothdata(dist_trip,"loess",30);
total_dist = (dist_trip(end)/1e3);% in km
%% split chart (moving & resting)
km_n = floor(total_dist);

for km = 1:km_n
    [~, ind] = min(abs(dist_trip/1e3-km));
    km_t(km) = dt(ind);
    km_elev(km) = elev_gain(ind);

end

km_dt = minutes(km_t-[dt(1),km_t(1:end-1)]);
km_delev = km_elev - [elev_gain(1), km_elev(1:end-1)];
%%
dts = seconds(dt-dt(1));
dts(1)=1;
dta = movsum([1,diff(dts)],100);
dista =movsum(([1,diff(dist_trip)]),100);
pace = (dta/60./dista*1e3);

% remove the part that too fast,(sometims car trace is also mixed)
pace(pace<human_pace_range(1)) = NaN;

pace_ave1 = dts(end)/60/total_dist; % unit = min/km, whole trip including the rest
pace_ave2 = mean(pace(pace<human_pace_range(2))); % unit = min/km, trip only includes the moving

speed = 1./pace; % unit = km/hour

plot(dt,dist_s,'.-');hold on;plot(dt,dist_trip);hold off

trip.distance = total_dist;
trip.elev_gain = elev_gain(end);
trip.pace_overall = pace_ave1;
trip.pace_moving = pace_ave2;
trip.time_overall = dts(end);
trip.split_chart = [[1:km_n]',km_dt',km_delev'];
trip.raw_data = {dt',lat, long, elev};
end