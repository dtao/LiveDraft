$(document).ready(function() {
  var $content    = $(".content");
  var $editTab    = $(".edit-tab");
  var $previewTab = $(".preview-tab");
  var $splitTab   = $(".side-by-side-tab");

  $editTab.click(function(){
    $content.attr("class", "content edit");
  });

  $previewTab.click(function(){
    $content.attr("class", "content preview");
  });

  $splitTab.click(function() {
    $content.attr("class", "content split");
  });
});
