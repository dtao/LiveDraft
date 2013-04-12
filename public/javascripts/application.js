$(document).ready(function() {
  LiveDraft.Pusher = new Pusher(LiveDraft.PusherKey);

  $(document).on("click", "#notice", function() {
    $(this).remove();
  });
});

$(window).unload(function() {
  $("body").addClass("loading");
  LiveDraft.Pusher.disconnect();
});
