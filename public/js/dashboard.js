$(function() {

	$('button[name=updateFoxes]').click(function() {
		FHMap.clearFoxes();
		FHMap.getFoxes();
	})

});