document.addEventListener("turbolinks:load", () => {
  if (gon.question_id) {
    App.cable.subscriptions.create(
      { channel: "QuestionsChannel", id: gon.question_id },
      {
        connected() {},

        disconnected() {
          this.perform("unsubscribed");
        },

        received({
          answer,
          question,
          answer_files,
          answer_links,
          answer_rating,
        }) {
          let list = document.getElementById("answers");
          list.insertAdjacentHTML(
            "beforeend",
            JST["templates/answer"]({
              answer,
              question,
              answer_files,
              answer_links,
              answer_rating,
            })
          );
        },
      }
    );
  } else {
    App.cable.subscriptions.create(
      { channel: "QuestionsChannel" },
      {
        connected() {
          this.perform("subscribed");
        },

        disconnected() {
          this.perform("unsubscribed");
        },

        received(data) {
          let list = document.getElementById("questions");

          list.insertAdjacentHTML("beforeend", data);
        },
      }
    );
  }
});
