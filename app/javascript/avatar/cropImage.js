//import 'cropperjs/dist/cropper.css'
import Cropper from 'cropperjs'

document.addEventListener('turbolinks:load', function () {
    const modalImageForm = document.querySelector('#modal-image-form')
    if (!modalImageForm) {
        return
    }
    const fileInput = document.querySelector('#file-input input[type=file]')
    const accountImage = document.getElementById('account-image')
    const croppedImage = document.getElementById('cropped-image')
    const originImage = document.querySelector('#origin-image')
    let cropper
    fileInput.addEventListener('change', function () {
        if (cropper) {
            cropper.destroy()
        }
        const file = fileInput.files[0]
        if (file) {
            const reader = new FileReader()
            reader.onload = function (e) {
                originImage.src = e.target.result
                cropper = new Cropper(originImage, {
                    aspectRatio: 1,
                    viewMode: 2
                })
            }
            reader.readAsDataURL(file)
            modalImageForm.classList.add('is-active')
        }
    })

    function closeModal(e) {
        e.classList.remove('is-active')
    }
    (document.querySelectorAll('.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button') || []).forEach((close) => {
        const target = close.closest('.modal')

        close.addEventListener('click', () => {
            closeModal(target)
        })
    })

    const saveButton = document.querySelector('#submit-modal')
    saveButton.addEventListener('click', function () {
        croppedImage.value = cropper.getCroppedCanvas().toDataURL()
        cropper.getCroppedCanvas().toBlob(function (blob) {
            const file = new File([blob], 'cropped_image.png', { type: 'image/png' })
            const reader = new FileReader()
            reader.onload = function (e) {
                accountImage.src = e.target.result
                console.log('accountImage', accountImage)
            }
            modalImageForm.classList.remove('is-active')
            reader.readAsDataURL(file)
        })
    })

    const cancelButton = document.querySelector('#cancel-modal')
    cancelButton.addEventListener('click', function () {
        modalImageForm.classList.remove('is-active')
    })

})
