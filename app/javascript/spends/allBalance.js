document.addEventListener('turbolinks:load', function() {
  const allBalanceButton = document.querySelector('.all-balance-button');
  
  if (allBalanceButton) {
    allBalanceButton.addEventListener('click', function(event) {
      event.preventDefault();
      const balance = parseFloat(this.getAttribute('data-balance'));

      const amountInput = document.querySelector('.field .amount');
      amountInput.value = balance;
      window.history.pushState({}, document.title, window.location.href);
    });
  }
});