jQuery(function($) {
    $("#ajax-indicator").ajaxStart(function(){ $(this).show();  });
    $("#ajax-indicator").ajaxStop(function(){ $(this).hide();  });

    $("#filter").change(function() {
        $.ajax({
            type: "GET",
            url: 'simple_kanban.js',
            data: $('#filter').serialize(),
            success: function(response) {
                $('#dashboard').html(response);
            },
            error: function(response) {
                $("div.error").html("Error filtering pane.  Please refresh the page.").show();
            }});
    });

});
