$(document).on("turbolinks:load", function () {
  $(document).on("ajax:success", function (e) {
    let target = e.target;
    if ($(target).is("a.favorite-answer-link")) {
      e.preventDefault();
      let answerId = $(e.target).data("answerId");

      $("svg.octicon").remove("octicon-star-fill").addClass("octicon-star");

      $(`#answer-${answerId}`)
        .find("svg.octicon")
        .addClass("octicon-star-fill");

      let answer = $(`#answer-${answerId}`);

      $(".answers").prepend(answer);
    }
  });
});
