$ ->
  callback = ->
  if $("#admin_blog_posts")
    $("#blog_post_text").ckeditor( callback, {
      language: 'de',
      toolbar: 'MyToolbar',
      toolbar_MyToolbar:
        [
          { name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
          { name: 'editing', items : [ 'Find','Replace','-','SelectAll'] },
          { name: 'insert', items : [ 'Image','Table', 'Iframe' ] },
          { name: 'basicstyles', items : [ 'Bold','Italic','Strike','-','RemoveFormat' ] },
          { name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Blockquote' ] },
          { name: 'links', items : [ 'Link','Unlink','Anchor' ] },
          { name: 'tools', items : [ 'Source', 'Maximize','-','About' ] }
        ]
    } )

  updateBlogType = ->
    if $("#blog_post_blog_type").val() == "podcast"
      $("#blog_post_mp3file_input").show()
    else
      $("#blog_post_mp3file_input").hide()

  $("#blog_post_blog_type").change( ->
    updateBlogType()
  )
  updateBlogType()
