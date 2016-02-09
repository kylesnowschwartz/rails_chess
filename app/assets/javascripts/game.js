$(document).ready(function() {
  var selected_squares = []

  $(".chessboard").click(function(event) {
    $(event.target).addClass('selected')

    selected_squares.push($(event.target))

    if (selected_squares.length === 2) {
      var from = selected_squares[0].attr('id')
      var to = selected_squares[1].attr('id')

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
        })
        // TODO - refactor to use promises

        selected_squares = []

        window.location.reload()
      }
    }
  })
})