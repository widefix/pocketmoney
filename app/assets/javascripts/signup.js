// Signup functionality
document.addEventListener('turbolinks:load', function() {
  // Terms agreement functionality
  const termsCheckbox = document.getElementById('terms-agreement');
  const submitButton = document.querySelector('input[type="submit"], button[type="submit"]');

  if (termsCheckbox && submitButton) {
    function updateSubmitButton() {
      submitButton.disabled = !termsCheckbox.checked;
      submitButton.classList.toggle('is-disabled', !termsCheckbox.checked);
    }

    termsCheckbox.addEventListener('change', updateSubmitButton);
    updateSubmitButton(); // Initial state
  }

  // Time zone detection
  if (typeof Intl !== 'undefined' && Intl.DateTimeFormat) {
    const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    const timeZoneInput = document.getElementById('user_time_zone');

    if (timeZoneInput && !timeZoneInput.value) {
      timeZoneInput.value = timeZone;
    }
  }
});
