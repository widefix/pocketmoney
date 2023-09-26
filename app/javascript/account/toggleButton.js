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
