(function(window, document, undefined) {
  console.log("in");
  var initialLocation;
  var sanFrancisco = new google.maps.LatLng(37.7756, -122.4193);
  var geocoder = new google.maps.Geocoder();
  var bounds = new google.maps.LatLngBounds();
  var infowindow = new google.maps.InfoWindow();

  initialize();

  function initialize() {
    var myOptions = {
      zoom: 14,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById("map-canvas"), myOptions);
      google.maps.event.addListener(map, 'click', function() {
                infowindow.close();
            });
    // Try W3C Geolocation (Preferred)
    if(navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
        map.setCenter(initialLocation);
        findRestaurants(initialLocation);
      }, function() {
        handleNoGeolocation(browserSupportFlag);
      });
    }
  // Browser doesn't support Geolocation
    else {
      browserSupportFlag = false;
      handleNoGeolocation();
    }
    //findRestaurants(initialLocation);

  function handleNoGeolocation() {
    initialLocation = sanFrancisco;
    map.setCenter(initialLocation);
    findRestaurants(initialLocation);
  }

  $('#mapsearch').click(function() {
    console.log("searched");
    var str = $('#map-bar').serialize();
    //$.post("/results/search", str);
    performGeocoding(str);
    //var newLoc = new google.maps.LatLng(18.1234, -145.9845);
    //map.setCenter(newLoc);
    console.log("searched2");
  })


  function performGeocoding(address) {
    geocoder.geocode( { 'address': address}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);
   /*     var marker = new google.maps.Marker({
            map: map,
            position: results[0].geometry.location
        });
        bounds.extend(marker.position);
        map.fitBounds(bounds);
        marker.setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png');*/
        findRestaurants(results[0].geometry.location);
      } else {
        alert("Geocode was not successful for the following reason: " + status);
      }
    });
  }


  function findRestaurants(location) {
    alert("in findRestaurants");
       var marker = new google.maps.Marker({
            map: map,
            position: location
        });
        bounds.extend(marker.position);
        map.fitBounds(bounds);
        marker.setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png');

    var loc_data = {lat: location.d, lon: location.e};
  console.log(location);
    $.ajax({
      url: "/results/getRestaurants",
      type: "POST",
      data: loc_data,
      success: function(data, textStatus, xhr) {
        console.log(map);
        console.log(data);
        for(var i = 0; i < data.length; i++) {
          var place = data[i];
          var latlng = new google.maps.LatLng(place.latitude, place.longitude);
          var marker = new google.maps.Marker({
            position: latlng,
            title:  place.name
          });

         google.maps.event.addListener(marker, 'click', function() {
                console.log("MARKER TIME");
                console.log(marker);
                infowindow.setContent(this.title);
                infowindow.open(map, this);
            });

          bounds.extend(latlng);
          map.fitBounds(bounds);
          marker.setMap(map);
          console.log(marker);
        }
      }
    }).done(function(data) {
      console.log(data); 
      })
    .fail(function() {
      console.log("error")
    })
    .always(function() { 
      console.log("complete"); 
      //$(location).attr('href', '/user/main_page')
    })

    console.log("ajax");
  }
  
}

google.maps.event.addDomListener(window, 'load', initialize);
})(this, this.document);
