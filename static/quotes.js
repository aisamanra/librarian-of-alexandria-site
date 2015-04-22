function doHighlight(ident) {
    $('.quote').css('backgroundColor', '#070707');
    $('.link').css('backgroundColor', '#070707');
    $("#"+ident).css("backgroundColor", "#171717");
}

function doLoadHighlight() {
    if (window.location.hash)
        doHighlight(window.location.hash.slice(1));
}
