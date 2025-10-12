// Load account image functionality
document.addEventListener('turbolinks:load', function() {
  var fileInput = document.querySelector('#file-input input[type=file]');
  if (!fileInput) {
    return
  }

  const accountImage = document.querySelector('#account-image');
  fileInput.addEventListener('change', function() {
    const file = fileInput.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = function(e) {
        accountImage.src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  });
});

// Load account background functionality
document.addEventListener('turbolinks:load', function() {
  var backgroundInput = document.querySelector('#background-input input[type=file]');

  if (backgroundInput) {
    const accountBackground = document.querySelector('#account-background');
    backgroundInput.addEventListener('change', function() {
      const file = backgroundInput.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
          accountBackground.style.backgroundImage = "url('" + e.target.result + "')";
          accountBackground.classList.add("account-has-bg")
        };
        reader.readAsDataURL(file);
      }
    });
  };
});
