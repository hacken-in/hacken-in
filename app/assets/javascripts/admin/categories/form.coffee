$ ->
  if $(".admin_categories.edit,.admin_categories.new").length > 0
    console.log "Hallo"

    updateItunesUrl = =>
      if $("#category_podcast_category").is(":checked")
        $("#category_itunes_url_input").show()
      else
        $("#category_itunes_url_input").hide()

    updateItunesUrl()

    $("#category_podcast_category").change (e) =>
      updateItunesUrl()

