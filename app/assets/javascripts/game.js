$(document).ready(function() {
  var selected_squares = [];
  var initialTurnCount = $(".chessboard").data("turn-count");

  $(".chessboard").click(function(event) {
    $(event.target).addClass('selected');

    selected_squares.push($(event.target))

    if (selected_squares.length === 2) {
      var from = selected_squares[0].attr('id');
      var to = selected_squares[1].attr('id');

      if (from === to) {
        selected_squares.length = 0

        $(event.target).removeClass('selected')
      } else {
        $.ajax({
          url: location.href + "/turns",
          type: "post",
          data: {"to" : to, "from" : from},
          success: function() {
            console.log('Saved Successfully')
          },
          error:function() {
           console.log('Error')
          }
        });
        // TODO - refactor to use promises

        selected_squares = []

        window.location.reload()
      };
    };
  });

  function poll(fn, callback, timeout, interval) {
    var endTime = Number(new Date()) + (timeout || 2000);
    interval = interval || 100;

    (function p() {
      // If the condition is met, callback
      if(fn()) {
        callback();
      }
      // If the condition isn't met but the timeout hasn't elapsed, go again
      else if (Number(new Date()) < endTime) {
        setTimeout(p, interval);
      }
    })();
  }

  if ($(".chessboard").length !== 0) {
    poll(
      function() {
        jQuery.ajax({
          url: location.href,
          success: function (result) {
            newTurnCount = parseInt($(result).find(".chessboard").attr("data-turn-count"))
          },
          async: false
        });

        if (initialTurnCount !== newTurnCount) {
          return true
        };
      },
      function() {
        window.location.reload()
      },
      300000,
      1000
    );
  }

})