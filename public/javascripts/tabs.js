$(document).ready(function() {
  var $editTab     = $(".edit-tab");
  var $previewTab  = $(".preview-tab");
  var $editorPage  = $(".editor");
  var $previewPage = $(".preview");

  $editTab.click(function(){
    $previewTab.removeClass("selected");
    $editTab.addClass("selected");
    $previewPage.hide();
    $editorPage.show();
  });

  $previewTab.click(function(){
    $editTab.removeClass("selected");
    $previewTab.addClass("selected");
    $editorPage.hide();
    $previewPage.show();
  });
});
