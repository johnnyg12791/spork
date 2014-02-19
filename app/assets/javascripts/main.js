function getCurrLoc() {
  var geocoder = new google.maps.Geocoder();
  var pos;
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      pos = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
      geocoder.geocode({'latLng': pos}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          if (results[1]) {
            var searchbar = document.getElementById("search-location");
            searchbar.value = results[1].formatted_address;
          }
          else {
            console.log('No results found');
          }
        }
        else {
          console.log('Geocoder failed due to: ' + status);
        }
      });
    });
  } 
  else {
    handleNoGeolocation(false);
  }
}

function handleNoGeolocation(errorFlag) {
  if (errorFlag) {
    console.log('Error: The Geolocation service failed.');
  } 
  else {
    alert('Error: Your browser doesn\'t support geolocation.');
  }
}

window.onload=function() {
  getCurrLoc();
  document.getElementById("location-button").onclick=getCurrLoc;
}