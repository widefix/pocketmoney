document.addEventListener('turbolinks:load', function() {
  var allBalanceButton = document.querySelector('.all-balance-button');
  
  if (allBalanceButton) {
    allBalanceButton.addEventListener('click', function(event) {
      event.preventDefault();
      var balance = parseFloat(this.getAttribute('data-balance'));

      var amountInput = document.querySelector('.field .amount');
      amountInput.value = balance;
      var descriptionInput = document.querySelector('.field .decscription');
      descriptionInput.value = 'Spend all balance';
    });
  }
});
