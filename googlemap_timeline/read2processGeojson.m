function [point_summary, path_summary] = read2processGeojson


fname = 'location-history.json'; 
fid = fopen(fname); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);

summary = [];
summaryt =[];
path_summary =[];


for n = 1:length(val)

    event = val{n};

    fields = string(fieldnames(event));

    if any(contains(fields,'activity'))
    


    [t0, t1, x, y] = process_event_activity(event);

    lane = [t1',  x', y'];
    summary = [summary;lane];
    summaryt = [summaryt;t0'];

    elseif any(contains(fields,'visit'))

        
        [t0, t1, x, y] = process_event_visit(event);

        lane = [t1(1),  x, y];
        summary = [summary;lane];
        summaryt = [summaryt;t0(1)];
    elseif any(contains(fields,'timelinePath'))
        path = process_event_timelinepath(event);
        path_summary = [path_summary; path];
    elseif any(contains(fields,'timelineMemory'))
        continue
    else
        disp('something not included!')
    end
end
point_summary = {summary, summaryt};
% post process for the result
% (summary, summaryt)
% path_summary

end

function [t0, t1, x, y] = process_event_activity(event)

infmt = 'yyyy-MM-dd''T''HH:mm:ss.SSS';

Time = event.startTime(1:end-6);
Timezone = event.startTime(end-5:end);

times = datenum(datetime(Time,'InputFormat',infmt,'TimeZone',Timezone));

Time = event.endTime(1:end-6);
Timezone = event.endTime(end-5:end);
timee = datenum(datetime(Time,'InputFormat',infmt,'TimeZone',Timezone));

start_geo = str2double(string(split(erase(event.activity.start,'geo:'),',')));

end_geo = str2double(string(split(erase(event.activity.end,'geo:'),',')));

ts = datetime(times, 'ConvertFrom', 'datenum');
tn = datetime(timee, 'ConvertFrom', 'datenum');

t0 = [ts, tn]; % readable time
t1 = [times, timee];   % timestamp

y = [start_geo(1), end_geo(1)]; % latitude
x = [start_geo(2), end_geo(2)]; % longtitude
end

function [t0, t1, x, y] = process_event_visit(event)

infmt = 'yyyy-MM-dd''T''HH:mm:ss.SSS';

Time = event.startTime(1:end-6);
Timezone = event.startTime(end-5:end);

times = datenum(datetime(Time,'InputFormat',infmt,'TimeZone',Timezone));

Time = event.endTime(1:end-6);
Timezone = event.endTime(end-5:end);
timee = datenum(datetime(Time,'InputFormat',infmt,'TimeZone',Timezone));

geo_data = event.visit.topCandidate.placeLocation;

geo = str2double(string(split(erase(geo_data,'geo:'),',')));


ts = datetime(times, 'ConvertFrom', 'datenum');
tn = datetime(timee, 'ConvertFrom', 'datenum');

t0 = [ts, tn]; % readable time
t1 = [times, timee];   % timestamp

y = geo(1); % latitude
x = geo(2); % longtitude
end

function path = process_event_timelinepath(event)

infmt = 'yyyy-MM-dd''T''HH:mm:ss.SSSZ';

Time = event.startTime;
Timezone = '-05:00';
times = datenum(datetime(Time,'InputFormat',infmt,'TimeZone',Timezone));

Time = event.endTime;
timee = datenum(datetime(Time,'InputFormat',infmt,'TimeZone',Timezone));

lat =[];
long =[];
t = [];

for n = 1:size(event.timelinePath,1)

    coor = event.timelinePath(n,1).point;

    geo = str2double(string(split(erase(coor,'geo:'),',')));

    lat = [lat, geo(1)];
    long = [long, geo(2)];
    t = [t, str2double(event.timelinePath(n,1).durationMinutesOffsetFromStartTime)];

end

ts = datetime(times, 'ConvertFrom', 'datenum');
tn = datetime(timee, 'ConvertFrom', 'datenum');

t0 = [ts, tn]; % readable time
t1 = [times, timee];   % timestamp

y = lat; % latitude
x = long; % longtitude

path = {t0, t1, x, y, t};
end
