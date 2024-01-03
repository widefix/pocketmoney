document.addEventListener('turbolinks:load', function() {
  const openButton = document.querySelector('.account .goals .open-accomplished-goals')
  const closeButton = document.querySelector('.account .accomplished-goals .close-accomplished-goals')
  const accomplishedGoals = document.querySelector('.account .accomplished-goals');
  const goals = document.querySelector('.account .goals');

  if (goals && openButton && closeButton) {
    openButton.addEventListener('click', function(event) {
      event.preventDefault();
      goals.classList.add('is-hidden');
      accomplishedGoals.classList.remove('is-hidden');
    });

    closeButton.addEventListener('click', function(event) {
      event.preventDefault();
      accomplishedGoals.classList.add('is-hidden');
      goals.classList.remove('is-hidden');
    });
  };
});
