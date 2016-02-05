$( document ).ready(function() {
  var targets = []
  var gameid = $(".chessboard").attr('class').split(" ")[1]

  $( ".chessboard" ).click(function( event ) {
    $(event.target).addClass('selected')

    targets.push($(event.target))

    if (targets.length === 2) {
      if (targets[0].text() === targets[1].text()) {
        targets.length = 0

        $(event.target).removeClass('selected')
      } else{
          var from = targets[0].attr('id')
          var to = targets[1].attr('id')

          $.ajax({
             url: "http://localhost:3000/games/" + gameid + "/turns" ,
             type: "post",
             data: {"to" : to, "from" : from},
             success: function(){
               console.log('Saved Successfully')
             },
             error:function(){
              console.log('Error')
             }
           })

          targets = []

          window.location.reload()
        }
      }
  })
})