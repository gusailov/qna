document.addEventListener("turbolinks:load", () => {
    App.cable.subscriptions.create(
        {
            channel: "CommentsChannel",
        },
        {
            connected() {
            },

            disconnected() {
                this.perform("unsubscribed");
            },

            received(data) {
                let list = document.getElementById(
                    `${data.commentable_type.toLowerCase()}-${
                        data.commentable_id
                    }-comments`
                );

                list.insertAdjacentHTML(
                    "beforeend",
                    `<div class="comment card m-2 text-muted" id="comment-${data.id}">${data.body}</div>`
                );
            },
        }
    );
});
