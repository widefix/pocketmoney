document.addEventListener('turbolinks:load', function() {
  const agreedToTermsCheckbox = document.getElementById("user_agreed_to_terms");

  if (agreedToTermsCheckbox) {
    const loginButton = document.getElementById("login-button");
    const googleButton = document.getElementById("google-button");

    agreedToTermsCheckbox.addEventListener("change", function() {
      var isCheckboxChecked = agreedToTermsCheckbox.checked;
      if (loginButton) {
        loginButton.disabled = !isCheckboxChecked;
      }
      if (googleButton) {
        googleButton.disabled = !isCheckboxChecked;
      }
    });
  }
});
