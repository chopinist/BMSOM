$(document).ready(function () {

    var opts = {
        lines: 10, // The number of lines to draw
        length: 4, // The length of each line
        width: 3, // The line thickness
        radius: 5, // The radius of the inner circle
        corners: 1, // Corner roundness (0..1)
        rotate: 0, // The rotation offset
        direction: 1, // 1: clockwise, -1: counterclockwise
        color: '#FFF', // #rgb or #rrggbb or array of colors
        speed: 1.5, // Rounds per second
        trail: 60, // Afterglow percentage
        shadow: false, // Whether to render a shadow
        hwaccel: false, // Whether to use hardware acceleration
        className: 'spinner', // The CSS class to assign to the spinner
        zIndex: 2e9, // The z-index (defaults to 2000000000)
        top: 'auto', // Top position relative to parent in px
        left: 'auto' // Left position relative to parent in px
    };

    $("body").on("keyup", "#search", function(){
        $('#users_form').trigger('submit.rails');
    });

    $("body").on("click", ".pagination a", function(){
        $.getScript(this.href);
        return false;
    });

    $('#users_form').on('ajax:beforeSend', function(event, data, status, xhr) {
        $(":button:not(#navbar-toggle)").attr("disabled", true);
        $("#titleSpinner").show();

        if ( $("#titleSpinner").children().length == 0 ) {
            var target = document.getElementById('titleSpinner');
            var spinner = new Spinner(opts).spin(target);
        }

    });

    $(document).on('ajaxComplete', function(event, data, status, xhr) {
        $("#titleSpinner").hide();
    });
});
