function hide(elem, search){
	if $(elem).hasClass('active') {
		$(search).show(2000);
	else
		$(search).hide(2000);
	}
}

$(document).ready(function() {
	if $(document.body).hasClass('ms-viewing-first') {
		//$('#inputGrp').show(2000);
		alert($(document.body).hasClass('ms-viewing-first'));
	}else {
		$('#inputGrp').hide(2000);
	}
});