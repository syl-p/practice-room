export const practice = (controller) => {
  Object.assign(controller, {
    /**
     * PUT /exercises/:id/favorites/[add/remove]
     * @param exerciseId int
     * @param action string
     **/
    favorite(exerciseId, action) {
      return new Promise((resolve, reject) => {
        fetch(`${this.root}/exercises/${exerciseId}/favorites/${action}`, {
          method: "PUT",
          credentials: "same-origin",
          headers: {
            "X-CSRF-Token": this.csrfToken,
          },
        })
          .then((response) => response.text())
          .then((response) => {
            resolve(response);
          })
          .catch((err) => {
            reject(err);
          });
      });
    },

    /**
     * GET /exercises/:id/practice/padd
     * @param exerciseId int
     **/
    practice(exerciseId, time = null) {
      return new Promise((resolve, reject) => {
        fetch(
          `${this.root}/exercises/${exerciseId}/practice/add/${time}`,
          {
            method: "GET",
            credentials: "same-origin",
            headers: {
              "X-CSRF-Token": this.csrfToken,
            },
          }
        )
          .then((response) => response.text())
          .then((response) => {
            resolve(response);
          })
          .catch((err) => {
            reject(err);
          });
      });
    },
  });
};
