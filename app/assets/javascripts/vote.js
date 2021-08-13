$(document).on("turbolinks:load", function () {
  $("a.vote")
    .on("ajax:success", function (e) {
      let item = e.detail[0].item;
      let rating = e.detail[0].item_rating;
      let controller_name = e.detail[0].controller_name;

      $(`div#${controller_name}-${item.id}-vote`)
        .find("div#vote-errors")
        .empty();

      $(`div#${controller_name}-${item.id}-rating`).replaceWith(
        `<div id="${controller_name}-${item.id}-rating">${controller_name} rate:${rating}</div>`
      );

      $(`div#${controller_name}-${item.id}-vote_up`).toggleClass("hidden");
      $(`div#${controller_name}-${item.id}-vote_down`).toggleClass("hidden");
      $(`div#${controller_name}-${item.id}-reset_vote`).toggleClass("hidden");
    })
    .on("ajax:error", function (e) {
      let errors = e.detail[0].errors;
      let item = e.detail[0].item;
      let controller_name = e.detail[0].controller_name;

      $.each(errors, function (index, value) {
        $(`div#${controller_name}-${item.id}-vote`)
          .find("div#vote-errors")
          .empty()
          .append(`<p>${value}</p>`);
      });
    });
});
