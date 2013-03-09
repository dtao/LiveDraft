$(document).ready(function() {
  var $content    = $(".content");
  var $editTab    = $(".edit-tab");
  var $previewTab = $(".preview-tab");
  var $splitTab   = $(".side-by-side-tab");
  var $draftsTab  = $(".drafts-tab");

  $editTab.click(function(){
    $content.attr("class", "content editing");
    window.LiveDraft.Editor.refresh();
  });

  $previewTab.click(function(){
    $content.attr("class", "content viewing");
  });

  $splitTab.click(function() {
    $content.attr("class", "content split");
    window.LiveDraft.Editor.refresh();
  });

  $draftsTab.click(function() {
    $content.attr("class", "content list");
  });
});
