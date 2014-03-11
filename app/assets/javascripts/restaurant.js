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

 // $('#addDish').click(function() {

  	// var price = document.getElementById("priceDish").value;
  	// var dishName = document.getElementById("nameDish").value;
   //  var description = document.getElementById("descriptionDish").value;
   //  var file = document.getElementById("fileDish").value; // can be ""
  	// if(dishName.length == 0) {
  	// 	alert("Please enter a name for your dish");
  	// 	return;
  	// }  	
   //  if (price.length != 0 && isNaN(price)) {
   //    alert("Please enter a real number for price");
   //    return;
   //  }

   //  var restaurantId = document.getElementById("addDish").getAttribute("data-restaurantid");
   //  var data = {"dishName": dishName, "dishPrice": price, "dishFile": file, "restaurantId": restaurantId, "description": description, "addReview": false};
   //  if(addingReview) {
   //    var rating = document.getElementById("rating").value;
   //    var review = document.getElementById("reviewDish").value;
   //    data["rating"] = rating;
   //    data["review"] = review;
   //    data["addReview"] = true;
   //  }

  //   $.ajax({
  //     url: "/restaurant/addDish",
  //     type: "POST",
  //     data: data,
  //     success: function(data, textStatus, xhr) {
  //       console.log("success");
  //     }
  //   }).done(function(data) {
  //     window.location.replace("/restaurant/menu/" + restaurantId);      
  //   })
  //   .fail(function() {
  //     console.log("error")
  //   })
  //   .always(function() { 
  //     console.log("complete"); 
  //     //$(location).attr('href', '/user/main_page')
  //   })


  // });

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

});
 
