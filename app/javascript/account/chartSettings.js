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
