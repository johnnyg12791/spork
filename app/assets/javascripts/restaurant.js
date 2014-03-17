$(document).ready(function() {

// used to validate the form when adding a dish on the menu page
// If the dish name field is empty or the price is specified but not a number or < 0, then
// the form submit is prevented and the user must change the fields - the fields entered
// will be highlighted red until clicked on by the user (they'll go back to white)
  $('#dishForm').submit(function (evt) {
      var priceInput = document.getElementById("priceDish");
      var price = priceInput.value;
      var dishNameInput = document.getElementById("nameDish")
      var dishName = dishNameInput.value;

      var errorDiv = document.getElementById("errorDivAddDish");
      errorDiv.innerHTML = "";
      dishNameError = "";
      priceNameError = "";

      if(dishName.length == 0) {
       dishNameError = "Please enter a name for your dish" + "</br>";
       dishNameInput.style.backgroundColor = '#FF4747';
       evt.preventDefault();
      }    
      if (price.length != 0 && (isNaN(price) || parseFloat(price) < 0)) {
        priceNameError = "Please enter a real number greater than 0 for price" + "</br>";
        priceInput.style.backgroundColor = '#FF4747';
        evt.preventDefault();
      }
      errorDiv.innerHTML = dishNameError + priceNameError;
      if(errorDiv.innerHTML != "") {
        errorDiv.innerHTML = errorDiv.innerHTML + "Please fix the above red entries before submitting";
      }
  });

// Used to toggle on the "Add a dish" form whether the user has specified if they wish
// to add a review immediately in the same form when they add the dish. This hiddenReviewBool.value
// is passed as a hidden parameter upon form submit to the controller for knowing whether to add a rating or not
   $('#showReviewForm').click(function() {
    var hiddenDiv = $('#hiddenDish');
    hiddenDiv.toggle();
    var hiddenReviewBool = document.getElementById("hiddenReviewBool");
    if(hiddenDiv.css('display') != 'none') {
      $('#reviewDishNow').html("Don't want to review now?");
      hiddenReviewBool.value = "true";
    } else {
           $('#reviewDishNow').html("Want to review the dish now?");
           hiddenReviewBool.value = "false";
    }
   });

// Used to toggle individual "on menu" items in the editSelected admin page
// for admins changing the status of items currently on the  menu
   $('.boolColumn').click(function () {
    input = $(this).find('input');
    changeValue(input);
   });

// When the header of the table for on menu is clicked, all of the true/falses
// will become inverted.
   $('#toggleAll').click(function () {
      $('.boolColumn').each( function( index, element) {
      input = $(this).find('input');
      changeValue(input);
     });
   });

// Used to toggle the on_menu display of the dish to false or true based on
// user input
   function changeValue(input) {
      value = input[0].value;
      if(value == "true") {
        value = "false";
      } else {
        value = "true"
      }
     input[0].value = value;
    }

// Used to validate the table form when an admin is editing dishes.
  $('#editDishesForm').submit(function (evt) {
    var errorDiv = document.getElementById("errorDiv");
    errorDiv.innerHTML = "";
    dishNameError = "";
    priceNameError = "";

    // all dish names must not be empty
    dishNames = $(".dishNameFields");
    for(var i=0; i<dishNames.length;i++) {
      input = $(dishNames[i]).find('input')[0];
      if(input.value == "") {
        dishNameError = "All dishes need names!" + "</br>";
        input.style.backgroundColor = '#FF4747'; // highlights red
      }
    }
    // all prices entered must be > 0 and a real number
    prices = $(".dishPriceFields");
    for(var i=0; i<prices.length; i++) {
      input = $(prices[i]).find('input')[0];
      price = input.value;
      if (price.length != 0 && isNaN(price) || price < 0.01) {
        priceNameError = errorDiv.innerHTML + "All prices must be positive numbers" + "</br>";
        input.style.backgroundColor = '#FF4747'; // highlights red
      }
    }
    // if there are errors found, the form submit is PREVENTED and the user must fix the red highlighted fields before proceeding
    errorDiv.innerHTML = dishNameError + priceNameError;
    if(errorDiv.innerHTML != "") {
      evt.preventDefault();
      errorDiv.innerHTML = errorDiv.innerHTML + "Please fix the above red entries before submitting";
    }
  });

// Used to change all red hightlighted fields (error fields) back to white when the user clicks on one.
   $('td input').click(function () {
    this.style.backgroundColor = "white";
   });

// Dynamically added elements don't have event handlers attached to them, so the $('.uploadPhoto') event handler below
// isn't attached to the new file fields. This uses recursion on each new field to add the handlers and new fields.
// Multiple field for file input was not working on my version of chrome - someone online said it only works for firefox
// This function adds a new file field input when the user uploads a new restaurant image, enabling them to add more images each time.
  function addNewFileField(elem) {
    var input = document.createElement("input");
    input.type = "file";
    input.name = "file[]";
    input.className = "uploadPhoto";
    $(input).on("change", function(){
      addNewFileField(this); // recursive call on newly generated field
    });
    $(elem).after(input);
  }

// When the admin uploads a photo (the file input changes), this is called to add a new file input field
  $('.uploadPhoto').change(function () {
    addNewFileField(this);
  });

// When the restaurant edit form is submitted, this validates the fields and prevents the submit if an error is found and
// highlights the fields in red that are incorrect. The default submit is prevented no matter what due to the code needing the
// geocoding to complete in an asynchronous manner; if the geocoding succeeds and there are no prior errors, then document.getElementById("restaurantEditForm").submit();
// is called to resubmit the form.
  $('#restaurantEditForm').submit(function (evt) {
    evt.preventDefault();
    var nameInput = document.getElementById("nameRestaurant");
    var restaurantName = nameInput.value;
    var addressInput = document.getElementById("addressRestaurant");
    var restaurantAddress = addressInput.value;
    var errorDiv = document.getElementById("restErrorDiv");
    errorDiv.innerHTML = "";
    restaurantNameError = "";
    addressError = "";
    geocodeError = "";
    // restaurant must have a name
    if(restaurantName.length == 0) {
     nameInput.style.backgroundColor = '#FF4747';
     restaurantNameError = "Your restaurant needs a name!" + "</br>";
   }
   // restaurant must have an address
   if(restaurantAddress.length == 0) {
     addressInput.style.backgroundColor = '#FF4747';
     addressError = "Your restaurant needs an address!" + "</br>";
   }
   errorDiv.innerHTML = restaurantNameError + addressError;//+ geocodeError;
   performGeocoding(restaurantAddress);
  });

// Used to validate the address entered to ensure that a latitude and longitude can be found by google api
// The latitude and longitude are placed in hidden input fields and passed to the controller on submit to store in the database
 function performGeocoding(address) {
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode( { 'address': address}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        var result = results[0].geometry.location
        var lat = results[0].geometry.location.lat();
        var lng = results[0].geometry.location.lng();
        // places the lat/long in hidden input fields to pass to controller
        var inputLat = document.getElementById("hiddenLat");
        var inputLng = document.getElementById("hiddenLng");
        inputLat.value = lat;
        inputLng.value = lng;
      } else {
        // invalid address - can't find lat/long for given address
        document.getElementById("addressRestaurant").style.backgroundColor = '#FF4747';
        var errorDiv = document.getElementById("restErrorDiv");
        errorDiv.innerHTML = errorDiv.innerHTML + "Your address cannot be found. Please check again, or be more specific with your address." + "</br>";
      }
        validateEvent();
    });
  }

// Validation for restaurant edit form - if errorDiv is still "", then no errors found and the form is resubmitted
// NOT using the default submit so it can proceed
  function validateEvent() {
    var errorDiv = document.getElementById("restErrorDiv");
    if(errorDiv.innerHTML != "") {
      errorDiv.innerHTML = errorDiv.innerHTML + "Please fix the above red entries before submitting";
      return;
    }
    alert("Restaurant Changes Saved");
    document.getElementById("restaurantEditForm").submit();
  }

// Used to change all "red error" fields back to white when user clicks on them
  $('.clickWhite').click(function () {
    this.style.backgroundColor = "white";
  });

});
 
