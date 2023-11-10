
document.addEventListener('turbolinks:load', function () {
    const topupButtons = document.querySelectorAll('#increase-button')
    const spendButtons = document.querySelectorAll('#decrease-button')
    if (!(topupButtons && spendButtons)) {
        return
    }
    const modalTopupForm = document.querySelector('#modal-topup-form')
    const modalSpendForm = document.querySelector('#modal-spend-form')

    const topupForm = document.getElementById('topup-form-with')
    const spendForm = document.getElementById('spend-form-with')

    spendButtons.forEach(function (changeButton) {
        changeButton.addEventListener('click', function () {
            modalSpendForm.classList.add('is-active')
            spendForm.action = changeButton.dataset.url
        })
    })

    topupButtons.forEach(function (changeButton) {
        changeButton.addEventListener('click', function () {
            modalTopupForm.classList.add('is-active')
            topupForm.action = changeButton.dataset.url
        })
    })

    function closeModal(e) {
        e.classList.remove('is-active')
    }

    (document.querySelectorAll('.modal-background, .modal-close, .modal-card .close-button') || []).forEach((close) => {
        const target = close.closest('.modal')

        close.addEventListener('click', () => {
            closeModal(target)
        })
    })
})