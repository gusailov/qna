$(document).on("turbolinks:load", function () {
  $(".edit-question-link").on("click", function (e) {
    e.preventDefault();
    $(this).addClass("hidden");
    let questionId = $(this).data("questionId");

    $(`form#edit-question-${questionId}`).removeClass("hidden");

    $(`form#edit-question-${questionId}`).submit(() => {
      $(`form#edit-question-${questionId}`).addClass("hidden");
      $(".edit-question-link").removeClass("hidden");
    });
  });
});
