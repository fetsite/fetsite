// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree .
//= require tinymce-jquery
//= require bootstrap
//= require bootstrap/colorpicker
//= require bootstrap/datepicker
//= require bootstrap/load-image.min
//= require bootstrap/image-gallery.min
//= require jquery-fileupload

function insertAttachment(url,name) {
	var ext = url.split('.').pop();
	var img_ext = [ "jpg", "png", "bmp" , "jpeg" ];
	var text_ext = [ "pdf" ];
	
	if ( img_ext.indexOf(ext) > -1) {
		tinymce.activeEditor.setContent(tinymce.activeEditor.getContent({format : 'raw'}) + "<img src=\"" + url + "\" title=\"" + name + "\">");
	}
	else if (text_ext.indexOf(ext) > -1) {
		tinymce.activeEditor.setContent(tinymce.activeEditor.getContent({format : 'raw'}) + "<a href=\"" + url + "\">" + name +"</a>");
	}
	else {
		alert("<a href=\"" + url + "\">" + "Link</a>");
	}
}
