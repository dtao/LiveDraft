$(document).ready(function() {
  var $body        = $("body");
  var $content     = $(".content");
  var $editTab     = $(".edit-tab");
  var $previewTab  = $(".preview-tab");
  var $splitTab    = $(".side-by-side-tab");
  var $draftsTab   = $(".drafts-tab");
  var $commentsTab = $(".hide-comments");

  $editTab.click(function(){
    $content.attr("class", "content editing");
    LiveDraft.Editor.refresh();
  });

  $previewTab.click(function(){
    $content.attr("class", "content viewing");
  });

  $splitTab.click(function() {
    $content.attr("class", "content split");
    LiveDraft.Editor.refresh();
  });

  $draftsTab.click(function() {
    $content.attr("class", "content list");
  });

  $commentsTab.click(function() {
    $body.toggleClass("comments-hidden");
  });
});
