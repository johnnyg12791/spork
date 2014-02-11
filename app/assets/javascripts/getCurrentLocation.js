(function(window, document, undefined) {
  var geocoder = new google.maps.Geocoder();
  var initialLocation;
  var sanFrancisco = new google.maps.LatLng(37.7756, -122.4193);
function getCurrLoc() {
  if(navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
  		reverseGeoCode(initialLocation);
    });
  } else {
  	    initialLocation = sanFrancisco;
  	    reverseGeoCode(initialLocation);
  }

  function reverseGeoCode() {
	  geocoder.geocode({'latLng': initialLocation}, function(results, status) {
	    if (status == google.maps.GeocoderStatus.OK) {
	      if (results[1]) {
	        var searchbar = document.getElementById("search-location");
	        searchbar.value = results[1].formatted_address;
	   	  }
		}
	  });
	}
}

  google.maps.event.addDomListener(window, 'load', getCurrLoc);
})(this, this.document);