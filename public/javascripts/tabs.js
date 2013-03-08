$(document).ready(function() {
  var $content    = $(".content");
  var $editTab    = $(".edit-tab");
  var $previewTab = $(".preview-tab");
  var $splitTab   = $(".side-by-side-tab");

  $editTab.click(function(){
    $content.attr("class", "content editing");
    window.LiveDraft.Editors["draft"].refresh();
  });

  $previewTab.click(function(){
    $content.attr("class", "content viewing");
  });

  $splitTab.click(function() {
    $content.attr("class", "content split");
    window.LiveDraft.Editors["draft"].refresh();
  });
});
