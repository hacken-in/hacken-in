$(function() {
  var login_link = $('.main-nav .login-nav-link');

  if (login_link.size() > 0) {
    login_link.click(function() {
      $('.loginform.loginform-popup').toggleClass('visible');
      return false;
    });
  }
});
