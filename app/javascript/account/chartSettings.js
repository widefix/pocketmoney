document.addEventListener('turbolinks:load', function() {
  const desktopOpenButton = document.getElementById('open-desktop-chart-setting-button');
  const desktopCloseButton = document.getElementById('close-desktop-chart-setting-button');
  const desktopChartSettings = document.getElementById('desktop-chart-settings');
  const desktopChart = document.getElementById('desktop-chart');

  const mobileOpenButton = document.getElementById('open-mobile-chart-setting-button');
  const mobileCloseButton = document.getElementById('close-mobile-chart-setting-button');
  const mobileChartSettings = document.getElementById('mobile-chart-settings');
  const mobileChart = document.getElementById('mobile-chart');


  if (desktopChart) {
    desktopOpenButton.addEventListener('click', function(event) {
      event.preventDefault();
      desktopChart.classList.add('is-hidden');
      desktopChartSettings.classList.remove('is-hidden');
    });

    desktopCloseButton.addEventListener('click', function(event) {
      event.preventDefault();
      desktopChartSettings.classList.add('is-hidden');
      desktopChart.classList.remove('is-hidden');
    });
  };

  if (mobileChart) {
    mobileOpenButton.addEventListener('click', function(event) {
      event.preventDefault();
      mobileChart.classList.add('is-hidden');
      mobileChartSettings.classList.remove('is-hidden');
    });

    mobileCloseButton.addEventListener('click', function(event) {
      event.preventDefault();
      mobileChartSettings.classList.add('is-hidden');
      mobileChart.classList.remove('is-hidden');
    });
  };
});
