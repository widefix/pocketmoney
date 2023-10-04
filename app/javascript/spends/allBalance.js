document.addEventListener('turbolinks:load', function() {
  const allBalanceButton = document.querySelector('.all-balance-button');
  
  if (allBalanceButton) {
    allBalanceButton.addEventListener('click', function(event) {
      event.preventDefault();
      const balance = parseFloat(this.getAttribute('data-balance'));

      const amountInput = document.querySelector('.field .amount');
      amountInput.value = balance;
      const descriptionInput = document.querySelector('.field .decscription');
      descriptionInput.value = 'Spend all balance';
    });
  }
});
