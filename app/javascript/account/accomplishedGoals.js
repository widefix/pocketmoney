document.addEventListener('turbolinks:load', function() {
  const desktopOpenButton = document.getElementById('open-desktop-accomplished-goals-button');
  const desktopCloseButton = document.getElementById('close-desktop-accomplished-goals-button');
  const desktopAccomplishedGoals = document.getElementById('desktop-accomplished-goals');
  const desktopGoals = document.getElementById('desktop-goals');

  const mobileOpenButton = document.getElementById('open-mobile-accomplished-goals-button');
  const mobileCloseButton = document.getElementById('close-mobile-accomplished-goals-button');
  const mobileAccomplishedGoals = document.getElementById('mobile-accomplished-goals');
  const mobileGoals = document.getElementById('mobile-goals');

  if (desktopGoals) {
    desktopOpenButton.addEventListener('click', function(event) {
      event.preventDefault();
      desktopGoals.classList.add('is-hidden');
      desktopAccomplishedGoals.classList.remove('is-hidden');
    });

    desktopCloseButton.addEventListener('click', function(event) {
      event.preventDefault();
      desktopAccomplishedGoals.classList.add('is-hidden');
      desktopGoals.classList.remove('is-hidden');
    });
  };

  if (mobileGoals) {
    mobileOpenButton.addEventListener('click', function(event) {
      event.preventDefault();
      mobileGoals.classList.add('is-hidden');
      mobileAccomplishedGoals.classList.remove('is-hidden');
    });

    mobileCloseButton.addEventListener('click', function(event) {
      event.preventDefault();
      mobileAccomplishedGoals.classList.add('is-hidden');
      mobileGoals.classList.remove('is-hidden');
    });
  };
});
