$(document).on("turbolinks:load", function () {
  let favoriteAnswer = $(".octicon-star-fill").parent();
  $(".answers").prepend(favoriteAnswer);
});
