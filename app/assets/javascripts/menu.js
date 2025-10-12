// Navbar functionality
document.addEventListener('turbolinks:load', function() {
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

  window.addEventListener('scroll', function() {
    var scrollTop = window.scrollY || document.documentElement.scrollTop;
    var scrollSpeedDown = scrollTop - lastScrollPosition;
    var scrollSpeedUp = lastScrollPosition - scrollTop;

    // go down
    if ((scrollTop > lastScrollPosition && scrollSpeedDown > hideSpeedDown && !isClicked) || isBottomed) {
      navbar.style.transform = 'translateY(-100%)';
      if (footer) { footer.style.opacity = '0.4'; }
      // go up
    } else if (scrollTop < lastScrollPosition && scrollSpeedUp > showSpeedUp) {
      navbar.style.transform = 'translateY(0)';
      if (footer) { footer.style.opacity = '1'; }
      // at the top
    } else if (scrollTop === 0) {
      navbar.style.transform = 'translateY(0)';
      if (footer) { footer.style.opacity = '1'; }
    }
    isBottomed = false;
    // at the bottom
    if ((window.innerHeight + scrollTop) >= document.body.scrollHeight) {
      navbar.style.transform = 'translateY(0)';
      if (footer) { footer.style.opacity = '1'; }
      isBottomed = true;
    }
    lastScrollPosition = scrollTop <= 0 ? 0 : scrollTop;
    isClicked = false;
  }, false);

  if (navbarBurgers) {
    navbarBurgers.addEventListener('click', function() {
      isClicked = true;
      const target = document.getElementById(navbarBurgers.dataset.target);

      navbarBurgers.classList.toggle('is-active');
      target.classList.toggle('is-active');
    });
  }
});

// Dropdown functionality
document.addEventListener('turbolinks:load', function() {
  var dropdowns = document.querySelectorAll('.dropdown');

  function upDropdowns(dropdown) {
    dropdown.classList.remove('is-active');
  }

  dropdowns.forEach(function(dropdown) {
    dropdown.addEventListener('click', function(e) {
      dropdown.classList.toggle('is-active');
    });

    dropdown.addEventListener('focusout', function(e) {
      if (!dropdown.contains(e.relatedTarget)) {
        upDropdowns(dropdown);
      }
    });
  });

  window.addEventListener('scroll', function() {
    dropdowns.forEach(function(dropdown) {
      upDropdowns(dropdown);
    });
  });
});

// Change amount functionality
document.addEventListener('turbolinks:load', function() {
    const topupButtons = document.querySelectorAll('#increase-button');
    const spendButtons = document.querySelectorAll('#decrease-button');
    const allBalanceButton = document.querySelector('.all-balance-button');
    const amountInput = document.querySelector('.field .amount');

    const modalTopupForm = document.querySelector('#modal-topup-form');
    const modalSpendForm = document.querySelector('#modal-spend-form');

    const topupForm = document.getElementById('topup-form-with');
    const spendForm = document.getElementById('spend-form-with');

    if (topupButtons) {
        topupButtons.forEach(function(changeButton) {
            changeButton.addEventListener('click', function() {
                modalTopupForm.classList.add('is-active');
                topupForm.action = changeButton.dataset.url;
            });
        });
    }

    if (spendButtons) {
        spendButtons.forEach(function(changeButton) {
            changeButton.addEventListener('click', function() {
                modalSpendForm.classList.add('is-active');
                spendForm.action = changeButton.dataset.url;
                allBalanceButton.dataset.balance = changeButton.dataset.balance;
            });
        });
    }
    
    if (allBalanceButton) {
        allBalanceButton.addEventListener('click', function(event) {
            event.preventDefault();
            amountInput.value = allBalanceButton.dataset.balance;
            window.history.pushState({}, document.title, window.location.href);
        });
    }

    function closeModal(e) {
        e.classList.remove('is-active');
        amountInput.value = '';
    }

    (document.querySelectorAll('.modal-background, .modal-close, .modal-card .close-button') || []).forEach(function(close) {
        const target = close.closest('.modal');

        if (close && target) {
            close.addEventListener('click', function() {
                closeModal(target);
            });
        }
    });
});
