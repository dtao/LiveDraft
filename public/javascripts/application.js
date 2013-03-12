window.LiveDraft = {};

$(document).ready(function() {
  LiveDraft.Pusher = new Pusher(LiveDraft.PusherKey);

  $("#notice").on("click", function() {
    $(this).remove();
  });
});
