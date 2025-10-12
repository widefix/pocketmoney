// Toggle button functionality
document.addEventListener('turbolinks:load', function() {
  var toggleButton = document.getElementById('toggle-button');
  if (!toggleButton) {
    return
  }
  var elementsHidden = true;
  var tbodyRows = Array.from(document.querySelectorAll('tbody.toggleable tr'));

  if (tbodyRows.length > 10) {
    toggleRows();
  }

  function toggleRows() {
    for (var i = 10; i < tbodyRows.length; i++) {
      var row = tbodyRows[i];
      row.style.display = (row.style.display === 'none') ? '' : 'none';
    }
  };

  toggleButton.addEventListener('click', function(e) {
    e.preventDefault();
    toggleRows();

    toggleButton.textContent = elementsHidden ? 'Hide' : 'Show all'; 
    elementsHidden = !elementsHidden;
  });
});

// Chart settings functionality
document.addEventListener('turbolinks:load', function() {
  const openButton = document.querySelector('.account .accumulative-balance .open-chart-settings')
  const closeButton = document.querySelector('.account .accumulative-balance-settings .close-chart-settings')
  const chartSettings = document.querySelector('.account .accumulative-balance-settings');
  const chart = document.querySelector('.account .accumulative-balance');

  if (chart && chartSettings && openButton && closeButton) {
    openButton.addEventListener('click', function(event) {
      event.preventDefault();
      chart.classList.add('is-hidden');
      chartSettings.classList.remove('is-hidden');
    });

    closeButton.addEventListener('click', function(event) {
      event.preventDefault();
      chartSettings.classList.add('is-hidden');
      chart.classList.remove('is-hidden');
    });
  };
});

// Accomplished goals functionality
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
