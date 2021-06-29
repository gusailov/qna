$(document).on("turbolinks:load", function () {
  $(".answers").on("click", ".edit-answer-link", function (e) {
    e.preventDefault();
    $(this).addClass("hidden");
    let answerId = $(this).data("answerId");

    $(`form#edit-answer-${answerId}`).removeClass("hidden");

    $(`form#edit-answer-${answerId}`).submit((e) => {
      $(`form#edit-answer-${answerId}`).addClass("hidden");
      $(".edit-answer-link").removeClass("hidden");
    });
  });
});
