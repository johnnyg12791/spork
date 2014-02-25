window.fbAsyncInit = function() {
  FB.init({
    appId      : '206449699555270',
    status     : true,
    cookie     : true, // enable cookies to allow the server to access the session
    xfbml      : true
  });

  FB.Event.subscribe('auth.login', function(response) {
    console.log('login');
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
        }
      }
    );
  });

  FB.Event.subscribe('auth.logout', function(response) {
    console.log('logout');
    $.ajax({
    type: "GET",
    url: "/user/logout",
    async: false
    });
    $('#logout-modal').modal('hide');
  });

};

(function(d, s, id){
   var js, fjs = d.getElementsByTagName(s)[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement(s); js.id = id;
   js.src = "//connect.facebook.net/en_US/all.js";
   fjs.parentNode.insertBefore(js, fjs);
 }(document, 'script', 'facebook-jssdk'));

// Here we run a very simple test of the Graph API after login is successful. 
// This testAPI() function is only called in those cases. 
function testAPI() {
  console.log('Welcome!  Fetching your information.... ');
  FB.api('/me', function(response) {
    console.log('Good to see you, ' + response.name + '.');
  });
}
