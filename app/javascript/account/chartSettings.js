document.addEventListener('turbolinks:load', function() {
  const desktopOpenButton = document.getElementById('open-desktop-chart-setting-button');
  const desktopCloseButton = document.getElementById('close-desktop-chart-setting-button');
  const desktopChartSettings = document.getElementById('desktop-chart-settings');
  const desktopChart = document.getElementById('desktop-chart');


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
});
