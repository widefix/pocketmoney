document.addEventListener('turbolinks:load', function() {
  const agreedToTermsCheckbox = document.getElementById("user_agreed_to_terms");

  if (agreedToTermsCheckbox) {
    const signupButton = document.getElementById("signup-button");
    const googleButton = document.getElementById("google-button");
    const facebookButton = document.getElementById("facebook-button");

    agreedToTermsCheckbox.addEventListener("change", function() {
      var isCheckboxChecked = agreedToTermsCheckbox.checked;
      if (signupButton) {
        signupButton.disabled = !isCheckboxChecked;
      }
      if (googleButton) {
        googleButton.disabled = !isCheckboxChecked;
      }
      if (facebookButton) {
        facebookButton.disabled = !isCheckboxChecked;
      }
    });
  }
});
