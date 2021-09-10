export const practice = controller => {
    Object.assign(controller, {

        /**
         * PUT /exercises/:id/favorites/[add/remove]
         * @param exerciseId int
         * @param action string 
        **/
        favorite(exerciseId, action) {
            return new Promise((resolve, reject) => {
                fetch(`${exerciseId}/favorites/${action}`, {
                    method: "PUT",
                    credentials: "same-origin",
                    headers: {
                      "X-CSRF-Token": this.csrfToken
                    }
                  })
                    .then(response => response.text())
                    .then((response) => {
                      resolve(response)
                    })
                    .catch((err) => {
                      reject(err)
                    })
            })

        },
        practice(exerciseId) {
          return new Promise((resolve, reject) => {
            fetch(`${exerciseId}/add_to_practice`, {
              method: "GET",
              credentials: "same-origin",
              headers: {
                "X-CSRF-Token": this.csrfToken
              }
            })
              .then(response => response.text())
              .then((response) => {
                resolve(response)
              })
              .catch((err) => {
                reject(err)
              })
          });
        }
    });
  };