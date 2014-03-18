function initializeMap() {
  // options for Google Maps
  var myOptions = {
    zoom: 14,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: false
  };
  // init Google Map
  map = new google.maps.Map(document.getElementById("map-canvas"), myOptions);
  google.maps.event.addListener(map, 'click', function() {
    infowindow.close();
  });

  // try HTML5 geolocation
  if(navigator.geolocation) {
    // get current position
    navigator.geolocation.getCurrentPosition(function(position) {
      // center map around pos and find restaurants
      pos = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
      map.setCenter(pos);
      findRestaurants(pos);
    });
  }
  // Browser doesn't support Geolocation
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

function findRestaurants(location) {
  var marker = new google.maps.Marker({
    position: location,
    title: "Your Location"
  });
  markersArray.push(marker);
  google.maps.event.addListener(marker, 'click', function() {
    infowindow.setContent(this.title);
    infowindow.open(map, this);
  });
  bounds.extend(marker.position);
  map.fitBounds(bounds);
  marker.setMap(map);
  marker.setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png');
  for(var i = 0; i < restaurants.length; i++) {
    var place = restaurants[i];
    var pictures = restaurants[i].pictures;
    var latlng = new google.maps.LatLng(place.latitude, place.longitude);
    var marker = new google.maps.Marker({
      position: latlng,
      title:  place.name,
      id: place.id,
      description: place.description,
      pictures: pictures
    });
    markersArray.push(marker);
    google.maps.event.addListener(marker, 'click', function() {
      var contentString = "<a href='/restaurant/show/" + this.id + "'>" + this.title + "</a></br> " + this.description;
      if(this.pictures) {
        contentString = contentString + "</br>";
        var numPics = this.pictures.length;
        var numPicsToDisplay = (numPics < 3) ? numPics : 3;
        for(var i = 0; i < numPicsToDisplay; i++) {
          contentString = contentString + "<img src='/assets/" + this.pictures[i].file_name + "' width='40' height='40'>";
        }
      }
      infowindow.setContent(contentString);//this.title);
      infowindow.open(map, this);
    });
    bounds.extend(latlng);
    map.fitBounds(bounds);
    marker.setMap(map);
  }
}

function clearOverlays() {
  bounds = new google.maps.LatLngBounds();
  for (var i = 0; i < markersArray.length; i++ ) {
    markersArray[i].setMap(null);
  }
  markersArray.length = 0;
}

$(document).ready(function() {
  var numPages = $('#data-for-paginator').data('num-pages')
  initPagination(numPages);

  // read data returned from the controller
  var search_item = $('#results-data').data('search-item');
  var search_loc = $('#results-data').data('search-loc');
  var search_lat = $('#results-data').data('search-lat');
  var search_long = $('#results-data').data('search-long')
  restaurants = $('#results-data').data('restaurants');

  // init Google Maps vars
  geocoder = new google.maps.Geocoder();
  bounds = new google.maps.LatLngBounds();
  infowindow = new google.maps.InfoWindow();
  markersArray = []; 

  // listener for distance selector
  $('#distance-selector').click(function(e) {
    var target = $(e.target);
    if (target.prop('tagName') == 'A') {
      e.preventDefault();

      var distance = target.attr('value');
      var data = { search_distance: distance, search_loc: search_loc, search_lat: search_lat,
        search_long: search_long, search_item: search_item };

      var ajax = $.ajax({
        url: "/results/search?render=partials_and_json_only",
        type: "POST",
        data: data
      });
      ajax.done(function(response) {
        response = $(response);
        restaurants = response.filter('#dish-results-data').data('restaurants');
        var new_search_results = response.filter('#search-results').html();
        $('#dish-results-container').html(new_search_results);
        numPages = response.filter('#data-for-paginator').data('num-pages')
        initPagination(numPages);
        clearOverlays();
        findRestaurants(pos);   
      });
      ajax.fail(function() {
        // do something
      });
    }

  });

google.maps.event.addDomListener(window, 'load', initializeMap);

});
