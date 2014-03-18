function getCurrLoc() {
  // change UI to show that we are searching for location
  getCurrLocUI(true);

  //  init geocoder
  var geocoder = new google.maps.Geocoder();

  // try HTML5 geolocation
  if(navigator.geolocation) {
    // if HTML5 geolocation is available...
    navigator.geolocation.getCurrentPosition(function(position) {
      var lat = document.getElementById("search-location-lat");
      var lng = document.getElementById("search-location-long");
      // write lat and long back into the document (so it can be sent with the form)
      lat.value = position.coords.latitude;
      lng.value = position.coords.longitude;
      // prepare position for Google Maps
      var pos = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
      // geocode position
      geocoder.geocode({'latLng': pos}, function(results, status) {
        // if good response from geocoder
        if (status == google.maps.GeocoderStatus.OK) {
          // if geocoder successful
          if (results[1]) {
            // write formatted address into form
            var searchbar = document.getElementById("search-location");
            var formattedAddress = results[1].formatted_address;
            searchbar.value = formattedAddress;
            // send ajax request to get most popular items near current location
            var ajax = $.ajax({
              type: "POST",
              url: "/results/search?render=partials_only&results=60&itemspr=6&rows=2",
              data: { search_lat: lat.value, search_long: lng.value }
            });
            // if ajax successful, display results
            ajax.done(function(response) {
              $('#popular-items').html(response);
              var numPages = $(response).filter('#data-for-paginator').data('num-pages');
              initPagination(numPages);
              getCurrLocUI(false, formattedAddress);
            });
            // if ajax is not successful...
            ajax.fail(function(response, status) {
              //do something
            });
          }
          // geocoder not successful
          else {
            console.log('No results found');
          }
        }
        // if bad response from geocoder...
        else {
          console.log('Geocoder failed due to: ' + status);
        }
      });
    });
  } 
  // if HTML5 geolocation is not available...
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
  if (on) {
    $("#location-button-icon").hide();
    $("#location-button-loading-gif").show();
    $("#location-button").attr("title", "Getting current location");
    $("#location-button").tooltip();
    $("#popular-items-heading").html("Getting your location...");
    $("#popular-items-progress-bar").slideDown();
    $("#popular-items").fadeTo("fast", 0.25);
  }
  if (!on) {
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