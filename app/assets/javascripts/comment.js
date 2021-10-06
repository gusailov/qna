$(document).on("turbolinks:load", function () {
    $(document).click(function (e) {
        let target = e.target;
        if ($(target).is("a.add-comment-link")) {
            e.preventDefault();
            $(target).addClass("hidden");
            let resourceId =
                $(target).data("resourceId") || $(target).data("resource_id");
            let resourceName =
                $(target).data("resourceName") || $(target).data("resource_name");
            $(`form#comment-${resourceName}-${resourceId}`).removeClass("hidden");

            $(`form#comment-${resourceName}-${resourceId}`).trigger("reset");

            $(`form#comment-${resourceName}-${resourceId}`).submit(() => {
                $(`form#comment-${resourceName}-${resourceId}`).addClass("hidden");
                $(".add-comment-link").removeClass("hidden");
            });
        }
    });

    $(document)
        .on("ajax:success", function (e) {
            let target = e.target;

            if ($(target).is("form.comment_submit")) {
                let item = e.detail[0].item;
                let controller_name = e.detail[0].controller_name;
                
                $(`div#${controller_name}-${item.commentable_id}-comments`)
                    .find("div#comment-errors")
                    .empty();
            }
        })
        .on("ajax:error", function (e) {
            let errors = e.detail[0].errors;
            let item = e.detail[0].item;
            let controller_name = e.detail[0].controller_name;

            $.each(errors, function (index, value) {
                $(`div#${controller_name}-${item.commentable_id}-comments`)
                    .find("div#comment-errors")
                    .empty()
                    .append(`<p>${value}</p>`);
            });
        });
});
