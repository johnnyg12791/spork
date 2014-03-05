(function(window, document, undefined) {
  var searched_loc = $('.temp_information').data('loc');

  var searched_dishes = $('.temp_information').data('dishes');
  var searched_restaurants = $('.temp_information').data('restaurants');

  // if(searched_dishes.length == 0) {
  //   alert("Your search query yielded no restaurants nearby with that item");
  //   alert("Broaden your distance, or try a new search query (searching for no items yields all restaurants nearby");
  // }
  console.log(searched_dishes);
  console.log(searched_restaurants);
  //alert(searched_restaurants);
  //alert(searched_dishes);

  var initialLocation;
  var sanFrancisco = new google.maps.LatLng(37.7756, -122.4193);
  var geocoder = new google.maps.Geocoder();
  var bounds = new google.maps.LatLngBounds();
  var infowindow = new google.maps.InfoWindow();

  var markersArray = [];

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
    if(searched_loc != null) {
       initialLocation = searched_loc;
       performGeocoding(initialLocation);
       //map.setCenter(initialLocation);
       //findRestaurants(initialLocation);
    } else if(navigator.geolocation) {
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




  $('#updatemap').click(function() {
    var distance = document.getElementById("distanceMap").value;
   
    if(isNaN(distance) == true) {
      alert("Please enter a real number for distance");
      return;
    }
    clearOverlays();
    var distanceNum = parseFloat(distance);
    var data = {"distance": distanceNum, "searchbar": searched_loc, "latbar": $('.temp_information').data('latitude'), "lngbar": $('.temp_information').data('longitude'), "itemsearch": $('.temp_information').data('item')};
    $.ajax({
      url: "/results/getDishesAndRestaurants?render=true",
      type: "POST",
      data: data,
      success: function(data, textStatus, xhr) {
        console.log("success");
        //return data;
      }
    }).done(function(data) {
      console.log(data.restaurants);
      searched_restaurants = data.restaurants;
      performGeocoding(initialLocation);
      
    })
    .fail(function() {
      console.log("error")
    })
    .always(function() { 
      console.log("complete"); 
      //$(location).attr('href', '/user/main_page')
    })
  });


    //findRestaurants(initialLocation);
    //$.post("/results/search", str);
    //performGeocoding(str);
    //var newLoc = new google.maps.LatLng(18.1234, -145.9845);
    //map.setCenter(newLoc);
 // })


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
        alert("Your requested address could not be found!");
        //alert("Geocode was not successful for the following reason: " + status);
        if(navigator.geolocation) {
          alert("Setting your current location instead")
          navigator.geolocation.getCurrentPosition(function(position) {
            initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
            map.setCenter(initialLocation);
            findRestaurants(initialLocation);
          });
        } else {
          alert("Since we cannot use your current location, setting San Francisco as default");
          initialLocation = sanFrancisco;
          map.setCenter(initialLocation);
          findRestaurants(initialLocation);
        }
     }
  });
 }

  function clearOverlays() {
    bounds = new google.maps.LatLngBounds();
    for (var i = 0; i < markersArray.length; i++ ) {
      markersArray[i].setMap(null);
    }
    markersArray.length = 0;
  }

/*
  function getPics(rest_id) {
     rest_data = {id: rest_id}
     $.ajax({
      url: "/results/get_pictures",
      type: "POST",
      data: rest_data,
      success: function(data, textStatus, xhr) {
        console.log("success");
        return data;
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
  }*/

  function findRestaurants(location) {
       var marker = new google.maps.Marker({
            //map: map,
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
        for(var i = 0; i < searched_restaurants.length; i++) {
          var place = searched_restaurants[i].restaurant;
          var pictures = searched_restaurants[i].pictures;
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
        
      
/*
    var loc_data = {lat: location.d, lon: location.e};
    $.ajax({
      url: "/results/get_restaurants",
      type: "POST",
      data: loc_data,
      success: function(data, textStatus, xhr) {
        console.log(data);
        for(var i = 0; i < data.length; i++) {
          var place = data[i].restaurant;
          var pictures = data[i].pictures;
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
                console.log(contentString);
                infowindow.setContent(contentString);//this.title);
                infowindow.open(map, this);
            });
          bounds.extend(latlng);
          map.fitBounds(bounds);
          marker.setMap(map);
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
  */
}

google.maps.event.addDomListener(window, 'load', initialize);
})(this, this.document);
