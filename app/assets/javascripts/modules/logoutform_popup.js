$(function() {
  var logout_link = $('.main-nav .profile-nav-link');

  if (logout_link.size() > 0) {
    logout_link.click(function() {
      $('.logoutform.logoutform-popup').toggleClass('visible');
      return false;
    });
  }
});
