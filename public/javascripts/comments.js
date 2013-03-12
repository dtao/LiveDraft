$(document).ready(function() {
  var $comments = $(".comment-list");

  if (LiveDraft.DraftId) {
    var channel = LiveDraft.Pusher.subscribe(LiveDraft.DraftId);
    channel.bind("comment", function(data) {
      $comments.prepend($(data.html));
    });
  }
});
