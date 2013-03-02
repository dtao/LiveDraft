$(document).ready(function() {
  var $editorPage  = $(".editor");
  var $previewPage = $(".preview");

  $(".edit-tab").click(function(){
    $previewPage.hide();
    $editorPage.show();
  });

  $(".preview-tab").click(function(){
    $editorPage.hide();
    $previewPage.show();
  });
});
