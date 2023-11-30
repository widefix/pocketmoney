
document.addEventListener('turbolinks:load', function () {
    const topupButtons = document.querySelectorAll('#increase-button')
    const spendButtons = document.querySelectorAll('#decrease-button')
    const allBalanceButton = document.querySelector('.all-balance-button');
    const amountInput = document.querySelector('.field .amount');

    if (!(topupButtons && spendButtons)) {
        return
    }
    const modalTopupForm = document.querySelector('#modal-topup-form')
    const modalSpendForm = document.querySelector('#modal-spend-form')

    const topupForm = document.getElementById('topup-form-with')
    const spendForm = document.getElementById('spend-form-with')


    topupButtons.forEach(function (changeButton) {
        changeButton.addEventListener('click', function () {
            modalTopupForm.classList.add('is-active')
            topupForm.action = changeButton.dataset.url
        })
    })

    spendButtons.forEach(function (changeButton) {
        changeButton.addEventListener('click', function () {
            modalSpendForm.classList.add('is-active')
            spendForm.action = changeButton.dataset.url
            allBalanceButton.dataset.balance = changeButton.dataset.balance
        })
    })

    allBalanceButton.addEventListener('click', function (event) {
        event.preventDefault();
        amountInput.value = allBalanceButton.dataset.balance;
        window.history.pushState({}, document.title, window.location.href);
    });

    function closeModal(e) {
        e.classList.remove('is-active')
        amountInput.value = ''
    }

    (document.querySelectorAll('.modal-background, .modal-close, .modal-card .close-button') || []).forEach((close) => {
        const target = close.closest('.modal')

        close.addEventListener('click', () => {
            closeModal(target)
        })
    })
})
