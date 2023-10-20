document.addEventListener('turbolinks:load', function () {
  var fileInput = document.querySelector('#file-input input[type=file]');
  if (!fileInput) {
    return
  }

  const accountImage = document.querySelector('#account-image');
  fileInput.addEventListener('change', function () {
    const file = fileInput.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = function (e) {
        accountImage.src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  });
});
