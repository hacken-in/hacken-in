$(function() {
  $('.gravatar_tooltip').tipsy({gravity: 'nw'});
});

function registerPreviewHook(identifier) {
  $('a.show-preview').click(function(e) {
    e.preventDefault();
    showPreview(identifier);
  });
}
      
function showPreview(identifier) {
  $(identifier).change(function() { 
    updatePreview(identifier) 
  }).keyup(function() { 
    updatePreview(identifier)
  });
        
  if ($('.markdown-preview').is(':hidden'))
    $('.markdown-preview').slideDown();
  else
    $('.markdown-preview').slideUp();
        
  $(identifier).change();
}
      
function updatePreview(identifier) {
  var comment_text = $(identifier).val();
  var generated_html = new Showdown.converter().makeHtml(comment_text);
  $('.markdown-preview').html(generated_html);
}

