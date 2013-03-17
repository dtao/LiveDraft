$(document).ready(function() {
  var $window = $(window);
  var $body   = $("body");

  var channel = LiveDraft.Pusher.subscribe(LiveDraft.DraftId);
  channel.bind("refresh", function() {
    $body.addClass("busy");

    // Reload the page, basically. But in an AJAX-y way.
    $.ajax({
      url: window.location,
      type: "GET",
      dataType: "html",
      success: function(html) {
        $body.html(html);
      },
      complete: function() {
        $body.removeClass("busy");
      }
    });
  });
});