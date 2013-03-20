$(document).ready(function() {
  var $window = $(window);
  var $body   = $("body");

  var channel = LiveDraft.Pusher.subscribe(LiveDraft.DraftId);

  channel.bind("refresh", function(data) {
    if (data.full_refresh) {
      window.location.reload();
      return;
    }

    $body.addClass("busy");

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
