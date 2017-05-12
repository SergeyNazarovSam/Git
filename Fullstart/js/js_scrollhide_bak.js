<script src="c:\Projects\Fullstart\js\js_scrollhide.js"></script>
<body style="height:1000px">
 
<script type="text/javascript">

function OffScroll () {
var winScrollTop = $(window).scrollTop();
$(window).bind('scroll',function () {
  $(window).scrollTop(winScrollTop);
});}

OffScroll ();  //Запустили отмену прокрутки
//$(window).unbind('scroll'); //Выключить отмену прокрутки
</script>
