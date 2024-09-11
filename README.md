# Footprint

## Preface

The motivation of starting this project is quite simple, I would like to know where I have been for my past of life and make a map to visualize it.
Inspired by the app such as "Fog of World", and after losing the record for too lazy to backup the data. I decide to make my footprint my own way.

Alltrails export
---------------------

In Alltrails, the trace of your past activity can be exported.
When viewing your recorded activities, you can click the three dots icon, go to "download route", select the "GPX track" and you can get a `*.gpx` file.
Repeat this for different activities until you satisfied.

Of course, you could have forgot to record you own activity. You can download the "official" trail, and rename it tailing with date such as `your_filename_#20240101`.
By doing so, your activity can also be recorded. (Just not as accurate as reality, but it's a good approximation!)

#### Folder of your export

Put all your Alltrails export GPX files into one folder, if the GPX doesn't contain time data, rename it with time labels if you wish to have more accurate.

Example folder:

TBA

Example Output:
[My hiking history](https://kepler.gl/demo/map?mapUrl=https://dl.dropboxusercontent.com/scl/fi/k72pmlbsuptnu14275cf8/keplergl_p8l9r2g.json?rlkey=pcwgiqd32n1ppuao6awiuqu6i&dl=0)

Google map timeline export
--------------------------

### Data before 2024

Google map previously provide a really good timeline storage until 2024, if you happen had exported previously (like what I had did). A method to retract the driving route will be .

### Data after 2024

#### Project OSRM: track you driving history

The historical data that google map timeline stored is in discrete geo-points format, which means it's not a completely continues trajectory.
However, it provides a good key information if.  

GPS Coordinates from your Photos
--------------------------------

Visualization
-------------

I use KeplerGL as the visualization tool of this project, this is easy to use, suitable to large-scale dataset and most importantly, open source!
