$(function() {
  $('.gravatar_tooltip').tipsy({gravity: 'nw'});

  $('.tags li a').each(function(index, anchor) {
    $(anchor).balloon({
      css: {
        opacity: 0.9,
        color: '#000'
      },
      contents: $(anchor).siblings('.tag_layer').html()
    });
  });

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

