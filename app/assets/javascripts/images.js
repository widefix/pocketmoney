// Image loading functionality
document.addEventListener('turbolinks:load', function() {
  // Load account image functionality
  const imageInputs = document.querySelectorAll('input[type="file"][data-preview]');

  imageInputs.forEach(function(input) {
    input.addEventListener('change', function(event) {
      const file = event.target.files[0];
      const previewId = input.getAttribute('data-preview');
      const preview = document.getElementById(previewId);

      if (file && preview) {
        const reader = new FileReader();

        reader.onload = function(e) {
          preview.src = e.target.result;
          preview.style.display = 'block';
        };

        reader.readAsDataURL(file);
      }
    });
  });

  // Load account background functionality
  const backgroundInputs = document.querySelectorAll('input[type="file"][data-background-preview]');

  backgroundInputs.forEach(function(input) {
    input.addEventListener('change', function(event) {
      const file = event.target.files[0];
      const previewId = input.getAttribute('data-background-preview');
      const preview = document.getElementById(previewId);

      if (file && preview) {
        const reader = new FileReader();

        reader.onload = function(e) {
          preview.style.backgroundImage = 'url(' + e.target.result + ')';
        };

        reader.readAsDataURL(file);
      }
    });
  });
});
