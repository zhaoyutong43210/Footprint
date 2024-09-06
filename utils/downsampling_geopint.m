function P_reduced = downsampling_geopint(P)

Path = [P.Latitude' P.Longitude'];

% remove nan values
i = isnan(Path);
i = not(i(:,1) & i(:,2));

Path_reduced = reducepoly(Path(i,:), 0.001);  % Ramer–Douglas–Peucker algorithm


% for debug use
% plot(Path(:,1),Path(:,2),'o-')
% hold on 
% plot(Path_reduced(:,1),Path_reduced(:,2),'*-')
% hold off

% find the indx for geopoint structure.
idxa = [];
for n = 1:length(Path_reduced) 
idx1 = find(Path(:,1)==Path_reduced(n,1));
idx2 = find(Path(:,2)==Path_reduced(n,2));
idx = intersect(idx1,idx2);
idxa = [idxa,idx(1)];
end

P_reduced = P(idxa);

% for debug use
% subplot(1,2,1)
% geoshow(P)
% subplot(1,2,2)
% geoshow(P_reduced)
end
