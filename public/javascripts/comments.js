$(document).ready(function() {
  var $comments = $(".comments");

  if (LiveDraft.DraftId) {
    var channel = LiveDraft.Pusher.subscribe(LiveDraft.DraftId);
    channel.bind("comment", function(data) {
      $comments.append($(data.html));
    });
  }
});
