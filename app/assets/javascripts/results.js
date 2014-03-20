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

  if (search_loc == null) {
    // try HTML5 geolocation
    if (navigator.geolocation) {
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
  else {
    pos = new google.maps.LatLng(search_lat, search_long);
    map.setCenter(pos);
    findRestaurants(pos);
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
  if (restaurants != undefined) {
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
}

function clearOverlays() {
  bounds = new google.maps.LatLngBounds();
  for (var i = 0; i < markersArray.length; i++ ) {
    markersArray[i].setMap(null);
  }
  markersArray.length = 0;
}

$(document).ready(function() {
  var numDishPages = $('#data-for-dish-paginator').data('num-pages');
  var numRestPages = $('#data-for-restaurant-paginator').data('num-pages');
  initPagination(numDishPages, numRestPages);

  // read data returned from the controller
  search_item = $('#results-data').data('search-item');
  search_loc = $('#results-data').data('search-loc');
  search_lat = $('#results-data').data('search-lat');
  search_long = $('#results-data').data('search-long')
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
        restaurants = response.filter('#restaurant-json').data('restaurants');
        var new_dish_results = response.find('#dish-results').html();
        var new_restaurant_results = response.find('#restaurant-results').html();
        $('#dish-results-container').html(new_dish_results);
        $('#restaurant-results-container').html(new_restaurant_results);
        numDishPages = response.find('#data-for-dish-paginator').data('num-pages');
        numRestPages = response.find('#data-for-restaurant-paginator').data('num-pages');
        initPagination(numDishPages, numRestPages);
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
