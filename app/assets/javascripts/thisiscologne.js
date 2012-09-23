$(function() {
  images = [];
  $.get('/thisiscologne.json', function(data) {
    if (data) {
      $.each(data, function(index, item) {
        images.push({dir: (Math.random() < 0.5 ? 'up' : 'down'), src: item.image_url, href: item.link, target:"_blank" });
      });
      $('#tic1').crossSlide({speed: 25, fade: 1, shuffle: true}, images);
      $('#tic2').crossSlide({speed: 25, fade: 1, shuffle: true}, images);
      $('#tic3').crossSlide({speed: 25, fade: 1, shuffle: true}, images);
    } else {
      $('.this-is-cologne').hide();
    }
  });
});
