$(document).ready(function() {
  addingReview = false;

  // function validateMyForm() {
  //   alert("ii");
  //   return false;
  // }

$('#dishForm').submit(function (evt) {
    var price = document.getElementById("priceDish").value;
    var dishName = document.getElementById("nameDish").value;
    if(dishName.length == 0) {
     alert("Please enter a name for your dish");
     evt.preventDefault();
     return;
    }    
    if (price.length != 0 && isNaN(price)) {
      alert("Please enter a real number for price");
      evt.preventDefault();
      return;
    }
   // window.history.back();
});


   $('#showReviewForm').click(function() {
    var hiddenDiv = $('#hiddenDish');
    //alert(hiddenDiv);
    hiddenDiv.toggle();
    var hiddenReviewBool = document.getElementById("hiddenReviewBool");
    if(hiddenDiv.css('display') != 'none') {
      $('#reviewDishNow').html("Don't want to review now?");
      //addingReview = true;
      hiddenReviewBool.value = "true";
    } else {
           $('#reviewDishNow').html("Want to review the dish now?");
           addingReview = false;
           hiddenReviewBool.value = "false";
    }
   });

   $('.boolColumn').click(function () {
    input = $(this).find('input');
    changeValue(input);
   });

   $('#toggleAll').click(function () {
      $('.boolColumn').each( function( index, element) {
      input = $(this).find('input');
      changeValue(input);
     });
   });

   function changeValue(input) {
      value = input[0].value;
      if(value == "true") {
        value = "false";
      } else {
        value = "true"
      }
     input[0].value = value;
    }


  $('#editDishesForm').submit(function (evt) {
    var errorDiv = document.getElementById("errorDiv");
    errorDiv.innerHTML = "";
    dishNameError = "";
    priceNameError = "";

    dishNames = $(".dishNameFields");
    for(var i=0; i<dishNames.length;i++) {
      input = $(dishNames[i]).find('input')[0];
      if(input.value == "") {
        dishNameError = "All dishes need names!" + "</br>";
        input.style.backgroundColor = '#FF4747';
      }
    }
    prices = $(".dishPriceFields");
    for(var i=0; i<prices.length; i++) {
      input = $(prices[i]).find('input')[0];
      price = input.value;
      console.log(price);
      if (price.length != 0 && isNaN(price) || price < 0.01) {
        priceNameError = errorDiv.innerHTML + "All prices must be positive numbers" + "</br>";
        input.style.backgroundColor = '#FF4747';
      }
    }
    errorDiv.innerHTML = dishNameError + priceNameError;
    if(errorDiv.innerHTML != "") {
      evt.preventDefault();
      errorDiv.innerHTML = errorDiv.innerHTML + "Please fix the above red entries before submitting";
    }
  });


   $('td input').click(function () {
    this.style.backgroundColor = "white";
   });

});
 
