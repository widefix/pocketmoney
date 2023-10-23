document.addEventListener('turbolinks:load', () => {
  var dropdowns = document.querySelectorAll('.dropdown')

  function upDropdowns(dropdown) {
    dropdown.classList.remove('is-active')
  }

  dropdowns.forEach(function (dropdown) {
    dropdown.addEventListener('click', function (e) {
      dropdown.classList.toggle('is-active')
    })

    dropdown.addEventListener('focusout', function (e) {
      if (!dropdown.contains(e.relatedTarget)) {
        upDropdowns(dropdown);
      }
    });
  })

  window.addEventListener('scroll', function () {
    dropdowns.forEach(function (dropdown) {
      upDropdowns(dropdown);
    });
  });
})