// Account functionality
document.addEventListener('turbolinks:load', function() {
  // Toggle button functionality
  const toggleButtons = document.querySelectorAll('[data-toggle]');

  toggleButtons.forEach(function(button) {
    button.addEventListener('click', function() {
      const targetId = button.getAttribute('data-target');
      const target = document.getElementById(targetId);

      if (target) {
        target.classList.toggle('is-hidden');
        button.classList.toggle('is-active');
      }
    });
  });

  // Chart settings
  if (typeof Chartkick !== 'undefined') {
    Chartkick.options = {
      colors: ['#3273dc', '#23d160', '#ffdd57', '#ff3860'],
      library: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero: true
            }
          }]
        }
      }
    };
  }

  // Accomplished goals functionality
  const accomplishedGoals = document.querySelectorAll('.accomplished-goal');

  accomplishedGoals.forEach(function(goal) {
    goal.addEventListener('click', function() {
      goal.classList.toggle('is-completed');
    });
  });
});
