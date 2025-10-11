// Menu functionality
document.addEventListener('turbolinks:load', function() {
  // Navbar functionality
  if (window.innerWidth > 1024) {
    return;
  }

  const navbarBurgers = document.querySelector('.navbar-burger');
  const navbar = document.querySelector('.navbar');
  const footer = document.querySelector('.navbar-footer');
  const hideSpeedDown = 15;
  const showSpeedUp = 25;
  var lastScrollPosition = 0;
  var isClicked = false;
  var isBottomed = false;

  if (navbarBurgers) {
    navbarBurgers.addEventListener('click', function() {
      const target = document.getElementById(navbarBurgers.dataset.target);
      navbarBurgers.classList.toggle('is-active');
      target.classList.toggle('is-active');
      isClicked = !isClicked;
    });
  }

  window.addEventListener('scroll', function() {
    var scrollTop = window.scrollY || document.documentElement.scrollTop;
    var scrollSpeedDown = scrollTop - lastScrollPosition;
    var scrollSpeedUp = lastScrollPosition - scrollTop;

    if ((scrollTop > lastScrollPosition && scrollSpeedDown > hideSpeedDown && !isClicked) || isBottomed) {
      if (navbar) navbar.style.transform = 'translateY(-100%)';
      if (footer) footer.style.transform = 'translateY(100%)';
    } else if (scrollTop < lastScrollPosition && scrollSpeedUp > showSpeedUp && !isClicked) {
      if (navbar) navbar.style.transform = 'translateY(0%)';
      if (footer) footer.style.transform = 'translateY(0%)';
    }

    lastScrollPosition = scrollTop;
  });
});

// Dropdown functionality
document.addEventListener('turbolinks:load', function() {
  const dropdowns = document.querySelectorAll('.dropdown');

  dropdowns.forEach(function(dropdown) {
    dropdown.addEventListener('click', function(event) {
      event.stopPropagation();
      dropdown.classList.toggle('is-active');
    });
  });

  document.addEventListener('click', function() {
    dropdowns.forEach(function(dropdown) {
      dropdown.classList.remove('is-active');
    });
  });
});

// Change amount functionality
document.addEventListener('turbolinks:load', function() {
  const changeAmountButtons = document.querySelectorAll('[data-change-amount]');

  changeAmountButtons.forEach(function(button) {
    button.addEventListener('click', function() {
      const targetId = button.getAttribute('data-target');
      const amount = parseFloat(button.getAttribute('data-amount'));
      const target = document.getElementById(targetId);

      if (target) {
        const currentValue = parseFloat(target.value) || 0;
        target.value = currentValue + amount;
      }
    });
  });
});
