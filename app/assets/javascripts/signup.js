// Terms agreement functionality
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

// Time zone functionality
document.addEventListener('turbolinks:load', function() {
    const topUpUtcElement = document.getElementById("topup-utc-time")
    if (!topUpUtcElement) {
        return
      }
    const topUpUtcTime = topUpUtcElement.getAttribute("data-utc-time");
    const userTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const userLocalTime = new Date(topUpUtcTime.toLocaleString("auto", { timeZone: userTimeZone }));

    const hours = userLocalTime.getHours();
    const minutes = userLocalTime.getMinutes();
    const formattedTime = hours.toString().padStart(2, "0") + ":" + minutes.toString().padStart(2, "0");

    document.getElementById("formatted-time").textContent = formattedTime;
});
