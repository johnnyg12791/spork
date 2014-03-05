function getCurrLoc() {
  getCurrLocUI(true);
  var geocoder = new google.maps.Geocoder();
  var pos;
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      pos = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
      geocoder.geocode({'latLng': pos}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          if (results[1]) {
            var searchbar = document.getElementById("search-location");
            var latBar = document.getElementById("lat-location");
            var lngBar = document.getElementById("lng-location");
            var formattedAddress = results[1].formatted_address;
            searchbar.value = formattedAddress;
            latBar.value = position.coords.latitude;
            lngBar.value = position.coords.longitude;
            // var ajax = $.ajax({
            //   type: "POST",
            //   url: "/results/getDishesAndRestaurants?json=true",
            //   data: { latBar: latBar.value, lngBar: lngBar.value }
            // });
            // ajax.done(function(response) {
            //   console.log(response);
            // });
            // ajax.fail(function(response, status) {
            //   //do something
            // });
          }
          else {
            console.log('No results found');
          }
        }
        else {
          console.log('Geocoder failed due to: ' + status);
        }
        getCurrLocUI(false, formattedAddress);
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

function getCurrLocUI(on, location) {
  if (on == true) {
    $("#location-button-icon").hide();
    $("#location-button-loading-gif").show();
    $("#location-button").attr("title", "Getting current location");
    $("#location-button").tooltip();
    $("#popular-items-heading").html("Getting your location...");
    $("#popular-items-progress-bar").show();
    $("#popular-items").fadeTo("fast", 0.25);
  }
  if (on == false) {
    $("#location-button-icon").show();
    $("#location-button-loading-gif").hide();
    $("#location-button").attr("title", "Get current location");
    $("#location-button").tooltip();
    $("#popular-items-heading").html("Currently popular near " + location + ":");
    $("#popular-items-progress-bar").slideUp();
    $("#popular-items").fadeTo("slow", 1.0);
  }
}

$(document).ready(function() {
  getCurrLoc();

  $("#location-button").click(function() {
    getCurrLoc();   
  });
});