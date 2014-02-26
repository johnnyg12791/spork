// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

function appLogin() {
  FB.api(
    "/me",
    function (response) {
      if (response && !response.error) {
        $.ajax({
          type: "POST",
          url: "/user/login",
          async: false,
          data: { fb_user_data: response }
        });
        $('#login-modal').modal('hide');
        location.reload(true);
      }
    }
  );
}

function appLogout() {
  $.ajax({
    type: "GET",
    url: "/user/logout",
    async: false,
  });
  location.reload(true);
}

$(document).ready(function() {
  $('#fb-login-button').click(function() {
    FB.login(function(response){
      appLogin();
    });
  });
  $('#app-logout-button').click(function() {
    appLogout();
  });
});