function onEnterMoje()
{
  $("#systip").html('W zakładce moje możesz ...');
  $("#systip").show("slide",{ direction: "up", distance: 70 }, 1000);
  $("#systip").click(function(){$("#systip").hide("slide",{ direction: "up", distance: 70 }, 1000);});

}