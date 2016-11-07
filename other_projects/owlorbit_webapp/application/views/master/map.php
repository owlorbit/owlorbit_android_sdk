<!DOCTYPE html>
<html>
<head>
  <meta charset=utf-8 />
  <title></title>
  <script src='https://api.mapbox.com/mapbox.js/v2.4.0/mapbox.js'></script>
  <link href='https://api.mapbox.com/mapbox.js/v2.4.0/mapbox.css' rel='stylesheet' />
  <style>
    body { margin:0; padding:0; }
    .map { position:absolute; top:0; bottom:0; width:100%; }
  </style>
</head>
<body>
<div id='map-one' class='map'> </div>
<script>
L.mapbox.accessToken = 'pk.eyJ1IjoidGltbnV3aW4iLCJhIjoiY2lzOGZjejYxMDVrczJ1cGtrZ2diaXgybyJ9.Qqxv9xQ6p8fANcoFWIe7bg';
var mapOne = L.mapbox.map('map-one', 'mapbox.light')
  .setView([37.8, -96], 4);
var myLayer = L.mapbox.featureLayer().addTo(mapOne);

var geojson = [
  

    <?php

		foreach($users as $row){
		    echo '{'.
		    'type: \'Feature\','.
		    'geometry: {'.
		      'type: \'Point\','.
		      'coordinates: ['.$row->longitude.', '.$row->latitude.']'.
		    '},'.
	    	'properties:{'.
	    		'icon:{'.
	    		'iconUrl:'.'\'https://api.owlorbit.com/uploads/profile_imgs/'.$row->id.'.png\','.
	    		'iconSize: [50,50],'.
	    		'iconAnchor: [25,25],'.
	    		'popupAnchor: [0, -25],'.
	    		'radius: 25,'.
	    		'className: \'dot\''.
	    		'}}},';
		}
    ?>
];
myLayer.on('layeradd', function(e) {
  var marker = e.layer,
    feature = marker.feature;
  marker.setIcon(L.icon(feature.properties.icon));
});
myLayer.setGeoJSON(geojson);
mapOne.scrollWheelZoom.disable();
</script>
</body>
</html>