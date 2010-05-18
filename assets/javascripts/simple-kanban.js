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

  $("#dialog-window").dialog({ autoOpen: false, modal: true, width: 600 });

  $('#dialog-window').
    dialog("option","buttons",
           {
             "Cancel": function() {
               $(this).dialog("close");
             },
             "OK": function() {
               alert('OK');
               $(this).dialog("close");
             }
           });

  $('#new-issue-dialog').click(function() {
    $('#dialog-window').dialog('open');
    return false;
  });

});
