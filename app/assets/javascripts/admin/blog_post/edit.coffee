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
          { name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote' ] },
          { name: 'links', items : [ 'Link','Unlink','Anchor' ] },
          { name: 'tools', items : [ 'Source', 'Maximize','-','About' ] }
        ]
    } )
